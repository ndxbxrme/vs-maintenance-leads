'use strict'

angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'setup',
    url: '/setup'
    templateUrl: 'routes/setup/setup.html'
    controller: 'SetupCtrl'
    data:
      title: 'Vitalspace Lettings - Setup'
      auth: ['superadmin','admin']