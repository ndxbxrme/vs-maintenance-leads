'use strict'

angular.module 'vs-maintenance-leads'
.controller 'HistoricCtrl', ($scope, $http, Sorter, DbItem, alert) ->
  $scope.dbItem = DbItem
  $scope.page = 1
  $scope.limit = 15
  $scope.mysearch =
    $like: ''
  $scope.pageChange = ->
    $('html, body').animate
      scrollTop: 0
    , 200
  $scope.historic = $scope.list 'issues',
    page: 1
    pageSize: $scope.limit
    sort: 'date'
    sortDir: 'DESC'
    where:
      $or: [
        deleted: $ne: null
      ,
        deleted: null
      ]
      search: $scope.mysearch
  $scope.sort = Sorter.create $scope.historic.args
  $scope.restoreIssue = (issue) ->
    $scope.modal
      template: 'issue-restore'
      controller: 'IssueDeleteCtrl'
      size: 'small'
    .then ->
      $http.get 'api/restore/' + issue._id
      .then ->
        alert.log 'Issue restored'      
      , (err) ->
        console.log err
    , (err) ->
      console.log 'err', err