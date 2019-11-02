'use strict'
 
angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'historic',
    url: '/historic'
    templateUrl: 'routes/historic/historic.html'
    controller: 'HistoricCtrl'
    data:
      title: 'Vitalspace Mainenance Leads - Historic Issues'
      auth: ['superadmin','admin','agency']