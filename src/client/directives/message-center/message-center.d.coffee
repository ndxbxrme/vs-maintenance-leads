'use strict'

angular.module 'vs-maintenance-leads'
.directive 'messageCenter', ($timeout, $filter, $rootScope, $stateParams, $http, TaskPopup) ->
  restrict: 'EA'
  templateUrl: 'directives/message-center/message-center.html'
  link: (scope, elem, attrs) ->
    scope.single 'landlords', _id:scope.issue.item.landlordId, (landlord) ->
      scope.messageRecipients = [
        name: 'Tenant: ' + scope.issue.item.tenantFirstName + ' ' + scope.issue.item.tenantLastName + ' - ' + scope.issue.item.tenantEmail, _id: 'tenant::' + scope.issue.item.tenantEmail        
      ]
      if landlord and landlord.item and Object.keys(landlord.item).length
        console.log 'landlordi tem', landlord.item
        scope.messageRecipients.push name: 'Landlord: ' + landlord.item.name + ' - ' + landlord.item.email, _id: 'landlord::' + landlord.item.email
      if scope.tasks.items[0]
        scope.single 'contractors', _id: scope.tasks.items[0].contractor, (contractor) ->
          scope.messageRecipients.push
            name: 'Contractor: ' + contractor.item.name + ' - ' + contractor.item.email, _id: 'contractor::' + contractor.item.email
    scope.sendEmail = ->
      console.log 'send email', scope.outgoingEmail
      scope.outgoingEmail.issueId = scope.issue.item._id
      scope.outgoingEmail.attachments = scope.issue.item.documents?.filter (document) ->
        document.$attached
      $http.post '/api/message-center/send', scope.outgoingEmail
      .then (response) ->
        console.log 'send response', response