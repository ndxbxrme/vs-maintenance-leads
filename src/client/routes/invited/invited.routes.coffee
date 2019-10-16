'use strict'

angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'invited',
    url: '/invite/:code'
    templateUrl: 'routes/invited/invited.html'
    controller: 'InvitedCtrl'
    data:
      title: 'Vitalspace Mainenance Leads - Invited'