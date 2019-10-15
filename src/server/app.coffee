'use strict'
 
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
      console.log 'i\'m doin summat at least'
      args.obj.address = "#{args.obj.address1}#{if args.obj.address2 then ', ' + args.obj.address2 else ''}, #{args.obj.postcode}"
      args.obj.tenant = "#{if args.obj.tenantTitle then args.obj.tenantTitle + ' ' else ''}#{args.obj.tenantFirstName} #{args.obj.tenantLastName}"
    cb true
  ndx.database.on 'update', assignAddressAndNames
  ndx.database.on 'insert', assignAddressAndNames
.use (ndx) ->
  ndx.app.get '/api/chase/:method/:issueId', ndx.authenticate(), (req, res, next) ->
    template = await ndx.database.selectOne req.params.method + 'templates', name: 'Chase'
    issue = await ndx.database.selectOne 'issues', _id:req.params.issueId
    if template and issue and issue.booked
      contractor = await ndx.database.selectOne 'contractors', _id:issue.booked
      if contractor
        issue.contractor = contractor.name
        if req.params.method is 'email'
          template.to = contractor.email.trim()
          template.text = marked template.text
          Object.assign template, issue
          ndx.email.send template
        else if req.params.method is 'sms'
          ndx.sms.send
            originator: 'VitalSpace'
            numbers: [contractor.phone.trim()]
            body: template.body
          , template
    res.end 'OK'
.start()
