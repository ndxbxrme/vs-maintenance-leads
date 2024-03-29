'use strict'

angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'contractor',
    url: '/contractor/:_id'
    templateUrl: 'routes/contractor/contractor.html'
    controller: 'ContractorCtrl'
    data:
      title: 'Vitalspace Mainenance Leads - Contractor'
      auth: ['superadmin','admin','agency']