'use strict'

angular.module 'vs-maintenance-leads'
.factory 'message', ->
  messages =
    #menu
    "menu-dashboard": 'Dashboard'
    "menu-users": 'Users'
    "menu-issues": 'Issues'
    "menu-contractors": 'Contractors'
    "menu-setup": 'Setup'
    #forms
    "forms-cancel": 'Cancel'
    "forms-submit": 'Submit'
    #user
    "user-heading": 'user'
    "user-name-label": 'Name'
    #users
    "users-heading": 'users'
    "users-button-new": 'New user'
    #issue
    "issue-heading": 'issue'
    "issue-name-label": 'Name'
    #issues
    "issues-heading": 'issues'
    "issues-button-new": 'New issue'
    #contractor
    "contractor-heading": 'contractor'
    "contractor-name-label": 'Name'
    #contractors
    "contractors-heading": 'contractors'
    "contractors-button-new": 'New contractor'
    
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
  m: m
.run ($rootScope, message) ->
  root = Object.getPrototypeOf $rootScope
  root.m = message.m