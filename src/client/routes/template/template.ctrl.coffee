'use strict'

angular.module 'vs-maintenance-leads'
.controller 'TemplateCtrl', ($scope, $stateParams, $state, $http) ->
  $scope.type = $stateParams.type
  cb = (template) ->
    if template
      $scope.template.locked = true
  if $stateParams.type is 'email'
    $scope.lang = 'jade'
    $scope.template = $scope.single 'emailtemplates', $stateParams.id, cb
  else
    $scope.lang = 'text'
    $scope.template = $scope.single 'smstemplates', $stateParams.id, cb
  $scope.save = ->
    if $scope.myForm.$valid
      $scope.template.save()
      $state.go 'setup'
  $scope.cancel = ->
    $state.go 'setup'
    
  $scope.defaultData = {}