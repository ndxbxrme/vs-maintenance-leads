'use strict'

angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'template',
    url: '/template/:id/:type'
    templateUrl: 'routes/template/template.html'
    controller: 'TemplateCtrl'
    data:
      title: 'Vitalspace Maintenance Leads - Template'
      auth: ['superadmin','admin']