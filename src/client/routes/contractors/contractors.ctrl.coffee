'use strict'

angular.module 'vs-maintenance-leads'
.controller 'ContractorsCtrl', ($scope, Sorter) ->
  $scope.contractors = $scope.list 'contractors',
    page: 1
    pageSize: 10
  $scope.contractors.sort = Sorter.create $scope.contractors.args