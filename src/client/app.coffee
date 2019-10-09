'use strict'

angular.module 'vs-maintenance-leads', [
  'ndx'
  'ui.router'
  'ngFileUpload'
]
.config ($locationProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'
  $locationProvider.html5Mode true
.run ($rootScope) ->
  $rootScope.makeDownloadUrl = (document) ->
    if document
      '/api/download/' + btoa JSON.stringify({path:document.path,filename:document.originalFilename})
try
  angular.module 'ndx'
catch e
  angular.module 'ndx', [] #ndx module stub