'use strict'

angular.module 'vs-maintenance-leads'
.controller 'HistoricCtrl', ($scope, Sorter, DbItem, alert) ->
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
      issue.history = issue.history or []
      issue.history.push
        deleted: issue.deleted
        completed: issue.completed
      issue.deleted = null
      issue.completed = null
      $scope.historic.save issue
      alert.log 'Issue restored'
    , (err) ->
      console.log 'err', err