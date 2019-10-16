'use strict'

angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'issue',
    url: '/issue/:_id'
    templateUrl: 'routes/issue/issue.html'
    controller: 'IssueCtrl'
    data:
      title: 'Vitalspace Mainenance Leads - Issue'
      auth: ['superadmin', 'admin', 'agency']