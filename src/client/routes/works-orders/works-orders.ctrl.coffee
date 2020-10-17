'use strict'

angular.module 'vs-maintenance-leads'
.controller 'WorksOrdersCtrl', ($scope, Sorter, DbItem) ->
  $scope.dbItem = DbItem
  $scope.page = 1
  $scope.limit = 15
  $scope.mysearch =
    $like: ''
  $scope.pageChange = ->
    $('html, body').animate
      scrollTop: 0
    , 200
  $scope.issues = $scope.list 'issues',
    page: 1
    pageSize: 10
    sort: 'date'
    sortDir: 'DESC'
    where:
      statusName: 'Booked'
      search: $scope.mysearch
      status:
        booked: true
        completed: false
        invoiced: false
  $scope.sort = Sorter.create $scope.issues.args