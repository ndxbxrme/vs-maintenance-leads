'use strict'
 
angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'contractors',
    url: '/contractors'
    templateUrl: 'routes/contractors/contractors.html'
    controller: 'ContractorsCtrl'
    data:
      title: 'contractors'
      auth: ['superadmin','admin','agency']