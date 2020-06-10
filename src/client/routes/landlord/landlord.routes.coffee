'use strict'

angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'landlord',
    url: '/landlord/:_id'
    templateUrl: 'routes/landlord/landlord.html'
    controller: 'landlordCtrl'
    data:
      title: 'Vitalspace Mainenance Leads - landlord'
      auth: ['superadmin','admin','agency']