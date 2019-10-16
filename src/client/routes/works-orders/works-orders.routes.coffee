'use strict'
 
angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'worksorders',
    url: '/works-orders'
    templateUrl: 'routes/works-orders/works-orders.html'
    controller: 'WorksOrdersCtrl'
    data:
      title: 'Vitalspace Mainenance Leads - Outstanding Works Orders'
      auth: ['superadmin','admin','agency']