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
    
  $scope.defaultData = 
    address: "22 Flixton Road, Urmston, M41 5AA"
    address1: "22 Flixton Road"
    address2: "Urmston"
    booked: "5da63ec84cba301a96c94984"
    cfpJobNumber: "986754"
    contractorArranged: "yes"
    date: 1571176184159
    details: "My boiler will not turn on and has no pressure"
    landlordInformed: "yes"
    modifiedAt: 1571177277049
    modifiedBy: "5da63cde4cba301a96c94983"
    postcode: "M41 5AA"
    repliedToTenant: "yes"
    source: "telephone"
    tenant: "Mr Richard Antrobus"
    tenantEmail: "richard@vitalspace.co.uk"
    tenantFirstName: "Richard"
    tenantLastName: "Antrobus"
    tenantPhone: "01617477807"
    tenantTitle: "Mr"
    title: "Boiler leaking"
    _id: "5da63efb4cba301a96c94985"