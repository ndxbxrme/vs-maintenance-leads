'use strict'

angular.module 'vs-maintenance-leads'
.directive 'header', ->
  restrict: 'EA'
  templateUrl: 'directives/header/header.html'
  replace: true