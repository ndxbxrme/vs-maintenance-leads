'use strict'
 
angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'contractors',
    url: '/contractors'
    templateUrl: 'routes/contractors/contractors.html'
    controller: 'ContractorsCtrl'
    data:
      title: 'Vitalspace Mainenance Leads - Contractors'
      auth: ['superadmin','admin','agency']