'use strict' 
marked = require 'marked'
require 'ndx-server'
.config
  database: 'db'
  tables: ['users', 'issues', 'tasks', 'contractors', 'emailtemplates', 'smstemplates', 'shorttoken']
  localStorage: './data'
  hasInvite: true
  hasForgot: true
  softDelete: true
.use (ndx) ->
  assignAddressAndNames = (args, cb) ->
    if args.changes?.deleted
      return cb true
    if args.table is 'issues'
      if args.obj.booked 
        contractor = await ndx.database.selectOne 'contractors', _id:args.obj.booked
        args.obj.contractor = contractor.name
      args.oldObj = args.oldObj or {}
      args.obj.address = "#{args.obj.address1 or args.oldObj.address1}#{if (args.obj.address2 or args.oldObj.address2) then ', ' + (args.obj.address2 or args.oldObj.address2) else ''}, #{args.obj.postcode or args.oldObj.postcode}"
      args.obj.tenant = "#{if args.obj.tenantTitle or args.oldObj?.tenantTitle then (args.obj.tenantTitle or args.oldObj.tenantTitle) + ' ' else ''}#{args.obj.tenantFirstName or args.oldObj.tenantFirstName} #{args.obj.tenantLastName or args.oldObj.tenantLastName}"
      args.obj.search = (args.obj.address or '') + '|' + (args.obj.tenant or '') + '|' + (args.obj.contractor or '') + '|' + (args.obj.title or args.oldObj?.title or '') + '|' + (args.obj.cfpJobNumber or args.oldObj?.cfpJobNumber or '')
      ###
      args.obj.status = args.obj.status or
        booked: false
        completed: false
        invoiced: false
      if typeof(args.obj.status) is 'string'
        args.obj.status = switch args.obj.status
          when 'Reported' then {booked:false,completed:false,invoiced:false}
          when 'Booked' then {booked:true,completed:false,invoiced:false}
          when 'Completed' then {booked:true,completed:true,invoiced:false}
          else {booked:false,completed:false,invoiced:false}
      args.obj.statusName = 'Reported'
      args.obj.statusName = 'Booked' if args.obj.status.booked
      args.obj.statusName = 'Completed' if args.obj.status.completed
      ###
    if args.table is 'tasks'
      contractor = await ndx.database.selectOne 'contractors', _id:args.obj.contractor or args.oldObj.contractor
      args.obj.contractorName = contractor.name
      ndx.database.update 'issues',
        contractorName: contractor.name
      , _id:args.obj.issue or args.oldObj.issue
    cb true
  updateStatus = (args, cb) ->
    if args.table is 'tasks'
      issue = await ndx.database.selectOne 'issues', _id: args.obj.issue
      if args.op is 'insert'
        issue.status = {booked:true,completed:false,invoiced:false}
        issue.statusName = 'Booked'
        issue.cpfJobNumber = args.obj.cpfJobNumber
        ndx.database.upsert 'issues', issue
      else
        if not args.changes.deleted
          issue.cfpJobNumber = args.obj.cfpJobNumber or args.oldObj?.cfpJobNumber
          ndx.database.upsert 'issues', issue
    else if args.table is 'issues'
      if args.op is 'insert'
        args.obj.statusName = 'Reported'
    cb true
  sendMessage = (issue, contractor, method, name, mailOrNo) ->
    template = await ndx.database.selectOne method + 'templates', name: name
    if issue and template
      if contractor and mailOrNo
        issue.contractor = contractor.name
        if method is 'email'
          template.to = mailOrNo.trim()
          template.subject = template.subject
          Object.assign template, issue
          ndx.email.send template
        else if method is 'sms'
          ndx.sms.send
            originator: 'VitalSpace'
            numbers: [mailOrNo.trim()]
            body: template.body
          , template
  sendMessages = (args, cb) ->
    if args.table is 'issues'
      if args.changes?.statusName?.to
        if args.changes.statusName.to isnt 'Reported'
          issue = Object.assign args.oldObj, args.obj
          task = await ndx.database.selectOne 'tasks', issue:issue._id
          if task
            contractor = await ndx.database.selectOne 'contractors', _id:task.contractor
            if issue and contractor
              switch args.changes.statusName?.to
                when 'Booked'
                  #sendMessage issue, contractor, 'email', 'TenantBooked', issue.tenantEmail
                  #sendMessage issue, contractor, 'sms', 'TenantBooked', issue.tenantPhone
                  sendMessage issue, contractor, 'email', 'Booked', contractor.email
                  sendMessage issue, contractor, 'sms', 'Booked', contractor.phone
                when 'Completed'
                  sendMessage issue, contractor, 'email', 'Completed', issue.tenantEmail
                  sendMessage issue, contractor, 'sms', 'Completed', issue.tenantPhone
                  #sendMessage issue, contractor, 'email', 'ContractorCompleted', contractor.email
                  #sendMessage issue, contractor, 'sms', 'ContractorCompleted', contractor.phone
              args.obj.notes = args.obj.notes or args.oldObj.notes or []
              if args.user
                args.obj.notes.push
                  date: new Date().valueOf()
                  text: args.changes.statusName?.to + ' - ' + contractor.name
                  item: 'Note'
                  side: ''
                  user: args.user
    cb true
  sendSockets = (args, cb) ->
    if args.table is 'issues'
      ndx.socket.emitToAll 'newIssue', args.obj
    cb true
  checkDeleted = (args, cb) ->
    if args.changes.deleted?.to
      if args.table is 'issues'
        args.obj.status = {}
        args.obj.statusName = 'Reported'
        ndx.database.update 'tasks',
          deleted: true
        ,
          issue: args.id
      if args.table is 'tasks'
        ndx.database.update 'issues',
          status: {}
          statusName: 'Reported'
        , args.oldObj.issue
    cb true
  ndx.database.on 'preUpdate', assignAddressAndNames
  ndx.database.on 'preInsert', assignAddressAndNames
  ndx.database.on 'update', updateStatus
  ndx.database.on 'insert', updateStatus
  ndx.database.on 'preUpdate', sendMessages
  ndx.database.on 'preInsert', sendMessages
  ndx.database.on 'insert', sendSockets
  ndx.database.on 'preUpdate', checkDeleted
.use (ndx) ->
  ndx.app.get '/api/emit', (req, res, next) ->
    issue = await ndx.database.selectOne 'issues'
    ndx.socket.emitToAll 'newIssue', issue
    res.end 'OK'
  ndx.app.get '/api/update-statuses', ndx.authenticate(), (req, res, next) ->
    issues = await ndx.database.select 'issues'
    for issue in issues
      if not issue.statusName
        issue.statusName = 'Reported'
        issue.statusName = 'Booked' if issue.booked
        issue.statusName = 'Completed' if issue.completed
      if issue.contractor and not issue.contractorName
        contractor = await ndx.database.selectOne 'contractors', _id:issue.contractor
        if contractor
          issue.contractorName = contractor.name
      ndx.database.upsert 'issues', issue
    res.end 'OK'
  ndx.app.post '/api/notes/:issueId', ndx.authenticate(), (req, res, next) ->
    ndx.database.update 'issues',
      notes: req.body.notes
    ,
      _id: req.params.issueId
    res.end 'OK'
  ndx.app.get '/api/chase/:method/:taskId', ndx.authenticate(), (req, res, next) ->
    template = await ndx.database.selectOne req.params.method + 'templates', name: 'Chase'
    task = await ndx.database.selectOne 'tasks', _id:req.params.taskId
    issue = await ndx.database.selectOne 'issues', _id:task.issue
    if template and issue and issue.isBooked
      contractor = await ndx.database.selectOne 'contractors', _id:issue.booked
      if contractor
        issue.contractor = contractor.name
        if req.params.method is 'email'
          template.to = contractor.email.trim()
          template.subject = template.subject
          Object.assign template, issue
          ndx.email.send template
        else if req.params.method is 'sms'
          ndx.sms.send
            originator: 'VitalSpace'
            numbers: [contractor.phone.trim()]
            body: template.body
          , template
        issue.item.notes = issue.item.notes or []
        issue.item.notes.push
          date: new Date().valueOf()
          text: 'Contractor - ' + contractor.name + ' chased by ' + req.params.method
          item: 'Note'
          side: ''
          user: user
        ndx.database.upsert 'issues', issue
    res.end 'OK'
  ndx.app.get '/api/inform/:method/:taskId', ndx.authenticate(), (req, res, next) ->
    template = await ndx.database.selectOne req.params.method + 'templates', name: 'Inform'
    task = await ndx.database.selectOne 'tasks', _id:req.params.taskId
    issue = await ndx.database.selectOne 'issues', _id:task.issue
    user = ndx.user
    if template and issue and issue.isBooked
      contractor = await ndx.database.selectOne 'contractors', _id:issue.booked
      if contractor
        issue.contractor = contractor.name
        if req.params.method is 'email'
          template.to = issue.tenantEmail.trim()
          template.subject = template.subject
          Object.assign template, issue
          ndx.email.send template
        else if req.params.method is 'sms'
          ndx.sms.send
            originator: 'VitalSpace'
            numbers: [issue.tenantPhone.trim()]
            body: template.body
          , template
        issue.item.notes = issue.item.notes or []
        issue.item.notes.push
          date: new Date().valueOf()
          text: 'Tenant informed by ' + req.params.method
          item: 'Note'
          side: ''
          user: user
        ndx.database.upsert 'issues', issue
    res.end 'OK'
  ndx.app.get '/api/complete/:issueId', ndx.authenticate(), (req, res, next) ->
    ndx.database.update 'issues',
      statusName: 'Completed'
    ,
      _id: req.params.issueId
    issue = await ndx.database.selectOne 'issues', _id: req.params.issueId
    if issue
      sendMessage = (method, mailOrNo) ->
        template = await ndx.database.selectOne method + 'templates', name: 'Complete'
        if issue and template
          contractor = await ndx.database.selectOne 'contractors', _id:issue.booked
          if contractor and mailOrNo
            issue.contractor = contractor.name
            if method is 'email'
              template.to = mailOrNo.trim()
              template.subject = template.subject
              Object.assign template, issue
              ndx.email.send template
            else if method is 'sms'
              ndx.sms.send
                originator: 'VitalSpace'
                numbers: [mailOrNo.trim()]
                body: template.body
              , template
      sendMessage 'email', issue.tenantEmail
      sendMessage 'sms', issue.tenantPhone
    res.end 'OK'
  ndx.app.get '/api/restore/:issueId', ndx.authenticate(), (req, res, next) ->
    issue = await ndx.database.selectOne 'issues', _id: req.params.issueId
    if issue
      issue.status = {}
      issue.statusName = 'Reported'
      issue.deleted = null
      issue.cfpJobNumber = null
      issue.notes = issue.notes or []
      issue.notes.push
        date: new Date().valueOf()
        text: 'Restored'
        item: 'Note'
        side: ''
        user: ndx.user
      await ndx.database.update 'tasks',
        deleted: true
      ,
        issue: issue._id
      ndx.database.upsert 'issues', issue
    res.end 'OK'
.start()
