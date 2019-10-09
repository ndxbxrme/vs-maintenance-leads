'use strict'

angular.module 'vs-maintenance-leads'
.controller 'SetupCtrl', ($scope, $http, $filter, $timeout, alert) ->
  $scope.editor = true
  $scope.newUser =
    role: 'agency'
  $scope.users = $scope.list 'users'
  $scope.emailTemplates = $scope.list 'emailtemplates'
  $scope.smsTemplates = $scope.list 'smstemplates'
  $scope.addUser = ->
    $scope.newUser.roles = {}
    $scope.newUser.roles[$scope.newUser.role] = {}
    delete $scope.newUser.role
    $http.post '/api/get-invite-code', $scope.newUser
    .then (response) ->
      $scope.inviteUrl = response.data
      alert.log 'Invite sent'
    , (err) ->
      $scope.inviteError = err.data
    $scope.newUser =
      role: 'agency'
  $scope.copyInviteToClipboard = ->
    $('.invite-url input').select()
    alert.log 'Copied to clipboard'
    document.execCommand 'copy'
 