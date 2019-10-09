'use strict'

angular.module 'vs-maintenance-leads'
.factory 'message', ->
  messages =
    "contractor-email-label": "Email Address"
    "contractor-heading": "Contractor"
    "contractor-name-label": "Name"
    "contractor-phone-label": "Mobile Number"
    "contractors-button-new": "New contractor"
    "contractors-heading": "Contractors"
    "forms-cancel": "Cancel"
    "forms-submit": "Submit"
    "issue-address1-label": "Street Address"
    "issue-address2-label": "Address Line 2"
    "issue-details-label": "Additional details about the issue"
    "issue-heading": "Maintenance Issue"
    "issue-label-address": "Address"
    "issue-label-detail": "Fault Detail"
    "issue-label-tenant": "Tenant"
    "issue-label-title": "Issue Title"
    "issue-name-label": "Name"
    "issue-postcode-label": "Postcode"
    "issue-tenantEmail-label": "Email"
    "issue-tenantFirstName-label": "First Name"
    "issue-tenantLastName-label": "Last Name"
    "issue-tenantPhone-label": "Phone"
    "issue-tenantTitle-label": "Title"
    "issue-title-label": "Issue Title"
    "issues-button-new": "New issue"
    "issues-heading": "Issues"
    "menu-contractors": "Contractors"
    "menu-dashboard": "Dashboard"
    "menu-issues": "Issues"
    "menu-setup": "Setup"
    "menu-users": "Users"
    "user-heading": "user"
    "user-name-label": "Name"
    "users-button-new": "New user"
    "users-heading": "users"
    
  fillTemplate = (template, data) -> 
    template.replace /\{\{(.+?)\}\}/g, (all, match) ->
      evalInContext = (str, context) ->
        (new Function("with(this) {return #{str}}"))
        .call context
      evalInContext match, data
  m = (key, obj) ->
    if messages[key]
      return if obj then fillTemplate(messages[key], obj) else messages[key]
    if /-placeholder$/.test key
      key = key.replace 'placeholder', 'label'
      if messages[key]
        return if obj then fillTemplate(messages[key], obj) else messages[key]
    console.log 'missing message:', key
    messages[key] = ''
    console.log messages
  m: m
.run ($rootScope, message) ->
  root = Object.getPrototypeOf $rootScope
  root.m = message.m