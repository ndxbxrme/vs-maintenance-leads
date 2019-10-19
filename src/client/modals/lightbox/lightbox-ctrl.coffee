
angular.module 'vs-maintenance-leads'
.controller 'LightboxCtrl', ($scope, data, $http, ndxModalInstance) ->
  console.log('booooom', data.media)
  $scope.imgSrc = data[0].URL
  $scope.imgIndex = data
  $scope.cancel = ->
    ndxModalInstance.dismiss()