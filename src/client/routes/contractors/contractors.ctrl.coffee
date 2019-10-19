'use strict'

angular.module 'vs-maintenance-leads'
.controller 'ContractorsCtrl', ($scope, Sorter) ->
  $scope.page = 1
  $scope.limit = 15
  $scope.pageChange = ->
    $('html, body').animate
      scrollTop: 0
    , 200
  $scope.contractors = $scope.list 'contractors',
    page: 1
    pageSize: $scope.limit
    sort: 'name'
    sortDir: 'ASC'
  , (contractors) ->
    for contractor in contractors.items
      contractor.issues = $scope.list 'issues',
        where:
          booked: contractor._id
          deleted: null
          completed: null
  $scope.contractors.sort = Sorter.create $scope.contractors.args