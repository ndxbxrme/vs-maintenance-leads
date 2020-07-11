'use strict'

angular.module 'vs-maintenance-leads'
.controller 'landlordsCtrl', ($scope, Sorter, alert) ->
  $scope.page = 1
  $scope.limit = 15
  $scope.pageChange = ->
    $('html, body').animate
      scrollTop: 0
    , 200
  $scope.landlords = $scope.list 'landlords',
    page: 1
    pageSize: $scope.limit
    sort: 'name'
    sortDir: 'ASC'
  , (landlords) ->
    for landlord in landlords.items
      landlord.issues = $scope.list 'issues',
        where:
          statusName: 'Booked'
          $or: [
            booked: landlord._id
          ,
            landlordName: landlord.name
          ]
  $scope.landlords.sort = Sorter.create $scope.landlords.args
  $scope.deletelandlord = (landlord) ->
    $scope.modal
      template: 'landlord-delete'
      controller: 'IssueDeleteCtrl'
      size: 'small'
    .then ->
      $scope.landlords.delete landlord
      $state.go 'landlords'
      alert.log 'landlord deleted'
    , (err) ->
      console.log 'err', err
