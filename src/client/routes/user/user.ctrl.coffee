'use strict'

angular.module 'vs-maintenance-leads'
.controller 'UserCtrl', ($scope, $stateParams) ->
  $scope.user = $scope.single 'users', $stateParams