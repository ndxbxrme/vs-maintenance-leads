'use strict'

angular.module 'vs-maintenance-leads'
.directive 'messageCenter', ($timeout, $filter, $rootScope, $stateParams, TaskPopup) ->
  restrict: 'EA'
  templateUrl: 'directives/message-center/message-center.html'
  link: (scope, elem, attrs) ->
    scope.messageRecipients = [
      name: 'Tenant: ' + scope.issue.item.tenantFirstName + ' ' + scope.issue.item.tenantLastName + ' - ' + scope.issue.item.tenantEmail, _id: 'tenant'
    ]