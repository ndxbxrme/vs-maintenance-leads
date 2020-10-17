'use strict'

angular.module 'vs-maintenance-leads'
.controller 'DashboardCtrl', ($scope, Sorter) ->
  now = new Date()
  yesterday = new Date().setHours(now.getHours() - 24)
  $scope.maintenanceToday = $scope.list 'issues',
    page: 1
    pageSize: 10
    where:
      date:
        $gt: yesterday.valueOf()
      search: $like: ''
      statusName: 'Reported'
    sort: 'date'
    sortDir: 'DESC'
  $scope.maintenanceToday.sort = Sorter.create $scope.maintenanceToday.args
  $scope.maintenanceOutstanding = $scope.list 'issues',
    page: 1
    pageSize: 10
    where:
      date:
        $lte: yesterday.valueOf()
      search: $like: ''
      statusName: 'Reported'
    sort: 'date'
    sortDir: 'DESC'
  $scope.maintenanceOutstanding.sort = Sorter.create $scope.maintenanceOutstanding.args
  $scope.worksOutstanding = $scope.list 'issues',
    page: 1
    pageSize: 10
    where:
      statusName: 'Booked'
      search: $like: ''
      status:
        booked: true
        completed: false
        invoiced: false
    sort: 'date'
    sortDir: 'DESC'
  $scope.worksOutstanding.sort = Sorter.create $scope.worksOutstanding.args
  $scope.invoiceOutstanding = $scope.list 'issues',
    page: 1
    pageSize: 10
    where:
      statusName: 'Booked'
      search: $like: ''
      status:
        completed: true
        booked: true
        invoiced: false
    sort: 'date'
    sortDir: 'DESC'
  $scope.invoiceOutstanding.sort = Sorter.create $scope.invoiceOutstanding.args
  true