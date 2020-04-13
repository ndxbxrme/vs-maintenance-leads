'use strict'

angular.module 'vs-maintenance-leads'
.controller 'ContractorsCtrl', ($scope, Sorter, alert) ->
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
          statusName: 'Booked'
          $or: [
            booked: contractor._id
            contractorName: contractor.name
          ]
          deleted: null
          completed: null
  $scope.contractors.sort = Sorter.create $scope.contractors.args
  $scope.deleteContractor = (contractor) ->
    $scope.modal
      template: 'contractor-delete'
      controller: 'IssueDeleteCtrl'
      size: 'small'
    .then ->
      $scope.contractors.delete contractor
      $state.go 'contractors'
      alert.log 'Contractor deleted'
    , (err) ->
      console.log 'err', err