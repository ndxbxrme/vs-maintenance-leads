'use strict'
 
angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'landlords',
    url: '/landlords'
    templateUrl: 'routes/landlords/landlords.html'
    controller: 'landlordsCtrl'
    data:
      title: 'Vitalspace Mainenance Leads - landlords'
      auth: ['superadmin','admin','agency']