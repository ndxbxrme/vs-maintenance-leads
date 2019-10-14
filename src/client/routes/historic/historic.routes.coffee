'use strict'
 
angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'historic',
    url: '/historic'
    templateUrl: 'routes/historic/historic.html'
    controller: 'HistoricCtrl'
    data:
      title: 'Historic'
      auth: ['superadmin','admin']