'use strict'

angular.module 'vs-maintenance-leads'
.controller 'DashboardCtrl', ($scope, Sorter) ->
  now = new Date()
  yesterday = new Date().setHours(now.getHours() - 24)
  $scope.maintenanceToday = $scope.list 'issues',
    where:
      date:
        $gt: yesterday.valueOf()
      booked: null
      completed: null
  $scope.maintenanceToday.sort = Sorter.create $scope.maintenanceToday.args
  $scope.maintenanceOutstanding = $scope.list 'issues',
    where:
      date:
        $lte: yesterday.valueOf()
      booked: null
      completed: null
  $scope.maintenanceOutstanding.sort = Sorter.create $scope.maintenanceOutstanding.args
  $scope.worksOutstanding = $scope.list 'issues',
    where:
      date:
        $gt: yesterday.valueOf()
      booked:
        $ne: null
      completed: null
  $scope.worksOutstanding.sort = Sorter.create $scope.worksOutstanding.args
  true