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
    "forms-book": "Book"
    "forms-delete": "Delete"
    "forms-edit": "Edit"
    "issue-address1-error-required": "Please enter an address"
    "issue-address1-label": "Street Address"
    "issue-address2-label": "Address Line 2"
    "issue-booked-error-required": "Please select"
    "issue-booked-label": "Booked"
    "issue-contractorArranged-error-required": "Please select"
    "issue-contractorArranged-label": "Contractor Arranged"
    "issue-details-label": "Additional details about the issue"
    "issue-heading": "Adding a Maintenance Issue"
    "issue-heading-add": "Add an issue"
    "issue-heading-edit": "Edit issue"
    "issue-heading-issue": "Maintenance Issue"
    "issue-label-address": "Address"
    "issue-label-detail": "Fault Detail"
    "issue-label-source": "Source"
    "issue-label-tenant": "Tenant"
    "issue-label-title": "Issue Title"
    "issue-landlordInformed-error-required": "Please select"
    "issue-landlordInformed-label": "Landlord Informed"
    "issue-name-label": "Name"
    "issue-postcode-error-required": "Please enter the postcode"
    "issue-postcode-label": "Postcode"
    "issue-repliedToTenant-error-required": "Please select"
    "issue-repliedToTenant-label": "Replied to Tenant"
    "issue-source-error-required": "Please select"
    "issue-source-label": "Source"
    "issue-tenantEmail-error-email": "Please enter a valid email address"
    "issue-tenantEmail-error-required": "Please enter an email address"
    "issue-tenantEmail-label": "Email"
    "issue-tenantFirstName-error-required": "Please enter the first name"
    "issue-tenantFirstName-label": "First Name"
    "issue-tenantLastName-error-required": "Please enter the last name"
    "issue-tenantLastName-label": "Last Name"
    "issue-tenantPhone-error-required": "Please enter the telephone number"
    "issue-tenantPhone-label": "Phone"
    "issue-tenantTitle-error-required": "Please enter a title"
    "issue-tenantTitle-label": "Title"
    "issue-title-error-required": "Please enter an issue title"
    "issue-title-label": "Issue Title"
    "issues-button-new": "New issue"
    "issues-heading": "Maintenance Lead Management"
    "menu-contractors": "Contractors"
    "menu-dashboard": "Dashboard"
    "menu-historic": "Historic"
    "menu-issue": "Add An Issue"
    "menu-issues": "Maintenance Issues"
    "menu-setup": "Setup"
    "menu-users": "Users"
    "menu-works-orders": "Outstanding Works Orders"
    "user-heading": "user"
    "user-name-label": "Name"
    "users-button-new": "New user"
    "users-heading": "users"
    "issues-heading-source": "Issue Source"
    "issues-heading-date": "Date Raised"
    "issues-heading-address": "Property Address"
    "issues-heading-tenant": "Tenant"
    "issues-heading-options": "Options"
    "modal-issue-delete-title": "Delete Issue"
    "modal-issue-delete-text": "Are you sure you wish to delete this issue?"
    "modal-issue-restore-title": "Restore Issue"
    "modal-issue-restore-text": "Are you sure you wish to restore this issue?"
    "modal-user-delete-title": "Delete User"
    "modal-user-delete-text": "Are you sure you wish to delete this user?"
    "modal-contractor-delete-title": "Delete Contractor"
    "modal-contractor-delete-text": "Are you sure you wish to delete this contractor?"
    "historic-heading": "Historic Issues"
    "historic-heading-date": "Date Raised"
    "historic-heading-address": "Property Address"
    "historic-heading-tenant": "Tenant"
    "historic-heading-contractor": "Contractor"
    "historic-heading-status": "Status"
    "historic-heading-view": "View Issue"
    "historic-heading-restore": "Restore Issue"
    "forms.myForm-jobnumber-label": "Input your CFP Job Number"
    "modal-issue-book-title": "What is your CFP Job Number?"
    "forms.myForm-jobnumber-error-required": "Please enter the CFP Job Number"
    "works-heading": "Outstanding Works Orders"
    "works-heading-date": "Date Raised"
    "works-heading-address": "Property Address"
    "works-heading-tenant": "Tenant"
    "works-heading-contractor": "Contractor"
    "works-heading-options": "Options"
    "issue-heading-cfp": "CFP Job Number"
    "issue-heading-tenant-contact": "Tenant Contact Details"
    "issue-heading-issue-title": "Issue Title"
    "issue-heading-fault-detail": "Fault Detail"
    "issue-heading-action-taken": "Action Taken"
    "issue-heading-contractor-assigned": "Contractor Assigned"
    "issue-heading-chase": "Chase this contractor"
    "issue-heading-notes": "Notes about this Maintenance Issue"
    "issue-label-email": "Email Contractor"
    "issue-label-sms": "SMS Contractor"
    "works-empty-table": "There are no outstanding work orders to show"
    "issues-empty-table": "There are no outstanding maintenance issues to show"
    "historic-empty-table": "There are no historic issues to show"
    "contractors-empty-table": "There are no contractors to show"
    "forgotUser-email-label": "Email address"
    "newUser-button-next": "Submit"
    "forgotUser-email-error-required": "Please enter your email address"
    "forgotUser-email-error-email": "Please enter a valid email address"
    "forgot-codeRequested-message": "Your code has been emailed"
    "issue-heading-inform": "Inform tenant"
    "issue-label-email-tenant": "Email Tenant"
    "issue-label-sms-tenant": "SMS Tenant"
    "issue-heading-complete": "Complete"
    "issue-label-complete": "Complete Issue"
    
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
    #console.log 'missing message:', key
    messages[key] = ''
    output = ''
    for key, val of messages
      output += '\n    "' + key + '": "' + val + '"'
    console.log output
    ''
  m: m
.run ($rootScope, message) ->
  root = Object.getPrototypeOf $rootScope
  root.m = message.m