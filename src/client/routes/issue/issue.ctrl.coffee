'use strict'

angular.module 'vs-maintenance-leads'
.controller 'IssueCtrl', ($scope, $stateParams) ->
  $scope.issue = $scope.single 'issues', $stateParams