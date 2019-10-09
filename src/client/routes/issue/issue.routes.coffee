'use strict'

angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'issue',
    url: '/issue/:_id'
    templateUrl: 'routes/issue/issue.html'
    controller: 'IssueCtrl'
    data:
      title: 'issue'
      auth: ['anon']