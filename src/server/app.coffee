'use strict'
marked = require 'marked'
require 'ndx-server'
.config
  database: 'db'
  tables: ['users', 'issues', 'contractors', 'emailtemplates', 'smstemplates', 'shorttoken']
  localStorage: './data'
  hasInvite: true
  hasForgot: true
  softDelete: true
.use (ndx) ->
  assignAddressAndNames = (args, cb) ->
    if args.table is 'issues'
      console.log args
      if args.obj.booked 
        contractor = await ndx.database.selectOne 'contractors', _id:args.obj.booked
        args.obj.contractor = contractor.name
      args.obj.address = "#{args.obj.address1 or args.oldObj.address1}#{if args.obj.address2 or args.oldObj.address2 then ', ' + args.obj.address2 or args.oldObj.address2 else ''}, #{args.obj.postcode or args.oldObj.postcode}"
      args.obj.tenant = "#{if args.obj.tenantTitle or args.oldObj.tenantTitle then (args.obj.tenantTitle or args.oldObj.tenantTitle) + ' ' else ''}#{args.obj.tenantFirstName or args.oldObj.tenantFirstName} #{args.obj.tenantLastName or args.oldObj.tenantLastName}"
      args.obj.search = (args.obj.address or '') + '|' + (args.obj.tenant or '') + '|' + (args.obj.contractor or '') + '|' + (args.obj.title or args.oldObj.title or '')
      args.obj.status = 'Reported'
      args.obj.status = args.obj.fixfloStatus if args.obj.fixfloStatus
      args.obj.status = 'Booked' if args.obj.booked
      args.obj.status = 'Deleted' if args.obj.deleted
      args.obj.status = 'Completed' if args.obj.completed
    cb true
  ndx.database.on 'preUpdate', assignAddressAndNames
  ndx.database.on 'preInsert', assignAddressAndNames
.use (ndx) ->
  ndx.app.get '/api/chase/:method/:issueId', ndx.authenticate(), (req, res, next) ->
    template = await ndx.database.selectOne req.params.method + 'templates', name: 'Chase'
    console.log 'template', template
    issue = await ndx.database.selectOne 'issues', _id:req.params.issueId
    if template and issue and issue.booked
      contractor = await ndx.database.selectOne 'contractors', _id:issue.booked
      if contractor
        console.log contractor.phone
        issue.contractor = contractor.name
        if req.params.method is 'email'
          template.to = contractor.email.trim()
          template.subject = marked template.subject
          Object.assign template, issue
          ndx.email.send template
        else if req.params.method is 'sms'
          ndx.sms.send
            originator: 'VitalSpace'
            numbers: [contractor.phone.trim()]
            body: template.body
          , template
    res.end 'OK'
  ndx.app.get '/api/inform/:method/:issueId', ndx.authenticate(), (req, res, next) ->
    template = await ndx.database.selectOne req.params.method + 'templates', name: 'Inform'
    issue = await ndx.database.selectOne 'issues', _id:req.params.issueId
    if template and issue and issue.booked
      contractor = await ndx.database.selectOne 'contractors', _id:issue.booked
      if contractor
        issue.contractor = contractor.name
        if req.params.method is 'email'
          template.to = issue.tenantEmail.trim()
          template.subject = marked template.subject
          Object.assign template, issue
          ndx.email.send template
        else if req.params.method is 'sms'
          ndx.sms.send
            originator: 'VitalSpace'
            numbers: [issue.tenantPhone.trim()]
            body: template.body
          , template
    res.end 'OK'
  ndx.app.get '/api/complete/:issueId', ndx.authenticate(), (req, res, next) ->
    ndx.database.update 'issues',
      completed:
        by: ndx.user
        at: new Date().valueOf()
    ,
      _id: req.params.issueId
    issue = await ndx.database.selectOne 'issue', _id: req.params.issueId
    if issue
      sendMessage = (method, mailOrNo) ->
        template = await ndx.database.selectOne method + 'templates', name: 'Complete'
        if issue and template
          contractor = await ndx.database.selectOne 'contractors', _id:issue.booked
          if contractor and mailOrNo
            issue.contractor = contractor.name
            if method is 'email'
              template.to = mailOrNo.trim()
              template.subject = marked template.subject
              Object.assign template, issue
              ndx.email.send template
            else if method is 'sms'
              ndx.sms.send
                originator: 'VitalSpace'
                numbers: [mailOrNo.trim()]
                body: template.body
              , template
      await sendMessage 'email', template.tenantEmail
      await sendMessage 'sms', template.tenantPhone
    res.end 'OK'
.start()
