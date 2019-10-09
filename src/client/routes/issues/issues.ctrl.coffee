'use strict'

angular.module 'vs-maintenance-leads'
.controller 'IssuesCtrl', ($scope, Sorter) ->
  $scope.issues = $scope.list 'issues',
    page: 1
    pageSize: 10
  $scope.issues.sort = Sorter.create $scope.issues.args