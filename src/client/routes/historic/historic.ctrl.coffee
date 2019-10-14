'use strict'

angular.module 'vs-maintenance-leads'
.controller 'HistoricCtrl', ($scope, Sorter, DbItem, alert) ->
  $scope.dbItem = DbItem
  $scope.page = 1
  $scope.limit = 15
  $scope.pageChange = ->
    $('html, body').animate
      scrollTop: 0
    , 200
  $scope.historic = $scope.list 'issues',
    page: 1
    pageSize: $scope.limit
    where:
      $or: [
        deleted: $ne: null
      ,
        deleted: null
      ]
  $scope.historic.sort = Sorter.create $scope.historic.args
  $scope.restoreIssue = (issue) ->
    $scope.modal
      template: 'issue-restore'
      controller: 'IssueDeleteCtrl'
      size: 'small'
    .then ->
      issue.deleted = null
      $scope.historic.save issue
      alert.log 'Issue deleted'
    , (err) ->
      console.log 'err', err