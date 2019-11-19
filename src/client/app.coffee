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
.run ($rootScope, $transitions, TaskPopup, alert, socket, $http) ->
  $rootScope.makeDownloadUrl = (document) ->
    if document
      '/api/download/' + btoa JSON.stringify({path:document.path,filename:document.originalFilename})
  $rootScope.medium = 'dd/MM/yyyy @ HH:mm'
  $transitions.onBefore {}, (trans) ->
    if not TaskPopup.getHidden()
      TaskPopup.hide()
      TaskPopup.cancelBubble = true
  $rootScope.bodyTap = (e) ->
    $http.get '/api/emit' if e.target.className is 'logo'
    $rootScope.mobileMenuOut = false
    elm = e.target
    isPopup = false
    while elm and elm.tagName isnt 'BODY'
      if elm.className is 'popup'
        isPopup = true
        break
      elm = elm.parentNode
    if not isPopup
      if not TaskPopup.getHidden()
        TaskPopup.hide()
        TaskPopup.cancelBubble = true    
  if socket
    socket.on 'newIssue', (issue) ->
      alert.log '<i class="fad fa-house-damage"></i><h3>' + issue.address + '</h3><p>' + issue.title + '</p>'
try
  angular.module 'ndx'
catch e
  angular.module 'ndx', [] #ndx module stub