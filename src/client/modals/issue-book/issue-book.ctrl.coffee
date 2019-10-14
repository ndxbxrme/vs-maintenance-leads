'use strict'

angular.module 'vs-maintenance-leads'
.controller 'IssueBookCtrl', ($scope, data, $http, ndxModalInstance) ->
  $scope.data = data
  $scope.forms = {}
  $scope.redirect = null
  $scope.saveFn = (cb) ->
    ndxModalInstance.close($scope.forms.myForm.jobnumber.$modelValue)
    cb false
  $scope.cancel = ->
    ndxModalInstance.dismiss()