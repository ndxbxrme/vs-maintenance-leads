'use strict'

angular.module 'vs-maintenance-leads'
.controller 'landlordCtrl', ($scope, $stateParams) ->
  $scope.landlord = $scope.single 'landlords', $stateParams      
  
  addressesMatch = (add1, add2) ->
    add1 = add1.toUpperCase().replace(/[, ]+/g, '')
    add2 = add2.toUpperCase().replace(/[, ]+/g, '')
    return false if not add1 or not add2
    i = Math.min 30, Math.min add1.length, add2.length
    good = true
    while i-- > 0
      good = good and (add1[i] is add2[i])
    good
      
  $scope.issues = $scope.list 'issues', null, (issues) ->
    issues.items.sort (a, b) -> if a.address > b.address then 1 else -1
    issues.items.sort (a, b) -> if a.postcode > b.postcode then 1 else -1
    currentAddress = "";
    currentPostcode = "";
    addresses = []
    issues.items = issues.items.map (issue) -> 
      if currentPostcode isnt issue.postcode.toUpperCase()
        addresses.push currentAddress
        currentAddress = issue.address
        currentPostcode = issue.postcode.toUpperCase()
      else
        if addressesMatch currentAddress, issue.address
          currentAddress = if currentAddress.length > issue.address.length then currentAddress else issue.address
        else
          addresses.push currentAddress
    $scope.addresses = []
    for address in addresses
      $scope.addresses.push address if address and not $scope.addresses.find (myaddress) -> myaddress.toUpperCase() is address.toUpperCase()
    $scope.addresses.sort (a, b) ->
      if a.replace(/\S*\d+\S*|^apartment|^apt|^flat|,/gi, '').trim() > b.replace(/\S*\d+\S*|^apartment|^apt|^flat|,/gi, '').trim() then 1 else -1
    $scope.addresses = $scope.addresses.map (address) ->
      _id: address
      name: address