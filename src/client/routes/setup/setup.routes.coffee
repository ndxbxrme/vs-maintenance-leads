'use strict'

angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'setup',
    url: '/setup'
    templateUrl: 'routes/setup/setup.html'
    controller: 'SetupCtrl'
    data:
      title: 'Vitalspace Lettings - Setup'
    resolve:
      user: (Auth) ->
        Auth.getPromise(['admin', 'superadmin'])