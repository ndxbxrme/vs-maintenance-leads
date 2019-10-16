'use strict'
 
angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'issues',
    url: '/issues'
    templateUrl: 'routes/issues/issues.html'
    controller: 'IssuesCtrl'
    data:
      title: 'Vitalspace Mainenance Leads - Issues'
      auth: ['superadmin','admin','agency']