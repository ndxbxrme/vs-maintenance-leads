'use strict'

angular.module 'vs-maintenance-leads'
.controller 'ContractorCtrl', ($scope, $stateParams) ->
  $scope.contractor = $scope.single 'contractors', $stateParams