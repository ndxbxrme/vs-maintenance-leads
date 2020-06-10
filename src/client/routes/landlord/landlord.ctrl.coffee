'use strict'

angular.module 'vs-maintenance-leads'
.controller 'landlordCtrl', ($scope, $stateParams) ->
  $scope.landlord = $scope.single 'landlords', $stateParams