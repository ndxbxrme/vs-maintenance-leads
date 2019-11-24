'use strict'

angular.module 'vs-maintenance-leads'
.controller 'DashboardCtrl', ($scope, Sorter) ->
  now = new Date()
  yesterday = new Date().setHours(now.getHours() - 24)
  $scope.maintenanceToday = $scope.list 'issues',
    page: 1
    pageSize: 20
    where:
      date:
        $gt: yesterday.valueOf()
      statusName: 'Reported'
    sort: 'date'
    sortDir: 'DESC'
  $scope.maintenanceToday.sort = Sorter.create $scope.maintenanceToday.args
  $scope.maintenanceOutstanding = $scope.list 'issues',
    page: 1
    pageSize: 20
    where:
      date:
        $lte: yesterday.valueOf()
      statusName: 'Reported'
    sort: 'date'
    sortDir: 'DESC'
  $scope.maintenanceOutstanding.sort = Sorter.create $scope.maintenanceOutstanding.args
  $scope.worksOutstanding = $scope.list 'issues',
    page: 1
    pageSize: 20
    where:
      statusName: 'Booked'
    sort: 'date'
    sortDir: 'DESC'
  $scope.worksOutstanding.sort = Sorter.create $scope.worksOutstanding.args
  true