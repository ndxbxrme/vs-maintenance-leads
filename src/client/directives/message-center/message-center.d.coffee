'use strict'

angular.module 'vs-maintenance-leads'
.directive 'messageCenter', ($timeout, $filter, $rootScope, $stateParams, TaskPopup) ->
  restrict: 'EA'
  templateUrl: 'directives/message-center/message-center.html'
  link: (scope, elem, attrs) ->
    console.log 'hiya'