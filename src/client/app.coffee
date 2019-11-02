'use strict'

angular.module 'vs-maintenance-leads', [
  'ndx'
  'ui.router'
  'ngFileUpload'
  'ui.gravatar'
  'ng-sumoselect'
  'date-swiper'
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
  $rootScope.medium = 'dd/MM/yyyy @ HH:mm'
try
  angular.module 'ndx'
catch e
  angular.module 'ndx', [] #ndx module stub