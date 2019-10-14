'use strict'

angular.module 'vs-maintenance-leads', [
  'ndx'
  'ui.router'
  'ngFileUpload'
  'ui.gravatar'
  'ng-sumoselect'
]
.config ($locationProvider, $urlRouterProvider, gravatarServiceProvider) ->
  $urlRouterProvider.otherwise '/'
  $locationProvider.html5Mode true
  gravatarServiceProvider.defaults =
    size: 16
    "default": 'mm'
    rating: 'pg'
.run ($rootScope) ->
  $rootScope.makeDownloadUrl = (document) ->
    if document
      '/api/download/' + btoa JSON.stringify({path:document.path,filename:document.originalFilename})
try
  angular.module 'ndx'
catch e
  angular.module 'ndx', [] #ndx module stub