'use strict'

angular.module 'vs-maintenance-leads'
.directive 'footer', ->
  restrict: 'EA'
  templateUrl: 'directives/footer/footer.html'
  replace: true