'use strict'

angular.module 'vs-maintenance-leads'
.directive 'messageCenter', ($timeout, $filter, $rootScope, $stateParams, $http, TaskPopup) ->
  restrict: 'EA'
  templateUrl: 'directives/message-center/message-center.html'
  link: (scope, elem, attrs) ->
    if scope.issue.item.newMessages
      scope.issue.item.newMessages = 0
      scope.issue.save()
    if scope.issue.item.messages
      scope.issue.item.messages = scope.issue.item.messages.sort (a, b) -> if a.date < b.date then 1 else -1
      #scope.issue.item.messages = scope.issue.item.messages.sort (a, b) -> if a.replyId > b.replyId then 1 else -1
    scope.single 'landlords', _id:scope.issue.item.landlordId or 'noone', (landlord) ->
      scope.messageRecipients = [
        name: 'Tenant: ' + scope.issue.item.tenant + ' - ' + scope.issue.item.tenantEmail, _id: 'Tenant::' + scope.issue.item.tenant + '::' + scope.issue.item.tenantEmail        
      ]
      if landlord and landlord.item and Object.keys(landlord.item).length
        console.log 'landlordi tem', landlord.item
        scope.messageRecipients.push name: 'Landlord: ' + landlord.item.name + ' - ' + landlord.item.email, _id: 'Landlord::' + landlord.item.name + '::' + landlord.item.email
      if scope.tasks.items[0]
        scope.single 'contractors', _id: scope.tasks.items[0].contractor, (contractor) ->
          scope.messageRecipients.push
            name: 'Contractor: ' + contractor.item.name + ' - ' + contractor.item.email, _id: 'Contractor::' + contractor.item.name + '::' + contractor.item.email
    scope.sendEmail = ->
      if scope.outgoingEmail and scope.outgoingEmail.item.messageTo
        scope.outgoingEmail.issueId = scope.issue.item._id
        scope.outgoingEmail.attachments = scope.issue.item.documents?.filter (document) ->
          document.$attached
        $http.post '/api/message-center/send', scope.outgoingEmail
        .then (response) ->
          scope.outgoingEmail = {}
          scope.composingMessage = false
          scope.issue.item.documents?.map (document) ->
            delete document.$attached
    scope.reply = (message) ->
      scope.composingMessage = true
      scope.outgoingEmail =
        item:
          subject: 'Re: ' + message.subject.replace(/^Re: /, '')
          messageTo: message.from + '::' + message.fromName + '::' + message.sender
        body: ''
        prevBody: message.body
        replyId: message.replyId
      document.querySelector('.page').scrollIntoView()
    scope.noAttachments = ->
      scope.issue.item.documents?.filter (doc) -> doc.$attached
      .length