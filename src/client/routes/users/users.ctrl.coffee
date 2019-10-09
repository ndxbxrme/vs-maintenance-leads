'use strict'

angular.module 'vs-maintenance-leads'
.controller 'UsersCtrl', ($scope, Sorter) ->
  $scope.users = $scope.list 'users',
    page: 1
    pageSize: 10
  $scope.users.sort = Sorter.create $scope.users.args