'use strict'

angular.module 'vs-maintenance-leads'
.controller 'IssueDeleteCtrl', ($scope, data, $http, ndxModalInstance) ->
  $scope.data = data
  $scope.submit = ->
    ndxModalInstance.close('thingy')
  $scope.cancel = ->
    ndxModalInstance.dismiss()