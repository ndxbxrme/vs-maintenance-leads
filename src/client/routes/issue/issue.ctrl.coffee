'use strict'

angular.module 'vs-maintenance-leads'
.controller 'IssueCtrl', ($scope, $stateParams, $state, $http, Auth, Upload, alert) ->
  $scope.fetched = false
  $scope.submitted = false
  $scope.sources = [
    name: 'FixFlo', _id: 'fixflo'
  ,
    name: 'Telephone', _id: 'telephone'
  ,
    name: 'Walk in', _id: 'walkin'
  ,
    name: 'Email', _id: 'email'
  ]
  $scope.yesno = [
    name: 'Yes', _id: 'yes'
  ,
    name: 'No', _id: 'no'
  ]
  myParams = 
    _id: $stateParams._id
    $or: [
      deleted: $ne: null
    ,
      deleted: null
    ]
  $scope.issue = $scope.single 'issues', myParams, (issue) ->
    issue.item.source = 'telephone' if not issue.item.source
    $scope.fetched = true
  $scope.contractors = $scope.list 'contractors'
  $scope.tasks = $scope.list 'tasks',
    where:
      issue: myParams._id
    sort: 'date'
    sortDir: 'DESC'
  $scope.addNote = ->
    if $scope.note
      if $scope.note.date
        for mynote in $scope.issue.item.notes or []
          if mynote.date is $scope.note.date and mynote.user?._id is $scope.note.user?._id
            mynote.text = $scope.note.text
            mynote.updatedAt = new Date()
            mynote.updatedBy = Auth.getUser()
            alert.log 'Note updated'
            break
      else
        $scope.issue.item.notes = $scope.issue.item.notes or []
        $scope.issue.item.notes.push
          date: new Date().valueOf()
          text: $scope.note.text
          item: 'Note'
          side: ''
          user: Auth.getUser()
        alert.log 'Note added'
      $http.post '/api/notes/' + $scope.issue.item._id, notes: $scope.issue.item.notes
      .then (res) ->
        #console.log res.data
      , (err) ->
        console.log 'error saving notes'
      $scope.note = null
  $scope.editNote = (note) ->
    $scope.note = JSON.parse JSON.stringify note
    $('.add-note')[0].scrollIntoView true 
  $scope.deleteNote = (note) ->
    for mynote in $scope.issue.item.notes or []
      if mynote.date is note.date and mynote.user?._id is note.user?._id
        $scope.issue.item.notes.remove mynote
        alert.log 'Note deleted'
        $scope.issue.save()
        $scope.note = null
        break
  $scope.deleteIssue = (issue) ->
    $scope.modal
      template: 'issue-delete'
      controller: 'IssueDeleteCtrl'
      size: 'small'
    .then ->
      $scope.issue.delete()
      $state.go 'dashboard'
      alert.log 'Issue deleted'
    , (err) ->
      console.log 'err', err
  $scope.showLightbox = (media) ->
    $scope.modal
      template: 'lightbox'
      controller: 'LightboxCtrl'
      size: 'large'
      data: media
    .then ->
      #just be happy
  $scope.chaseContractor = (method, task) ->
    $http.get '/api/chase/' + method + '/' + task._id
    .then (res) ->
      if res.data is 'OK'
        alert.log 'Contractor chased' 
        $scope.issue.item.notes = $scope.issue.item.notes or []
        $scope.issue.item.notes.push
          date: new Date().valueOf()
          text: 'Contractor chased by ' + method
          item: 'Note'
          side: ''
          user: Auth.getUser()
        $scope.issue.save()
  $scope.informTenant = (method, task) ->
    $http.get '/api/inform/' + method + '/' + task._id
    .then (res) ->
      if res.data is 'OK'
        alert.log 'Tenant informed' 
        $scope.issue.item.notes = $scope.issue.item.notes or []
        $scope.issue.item.notes.push
          date: new Date().valueOf()
          text: 'Tenant informed by ' + method
          item: 'Note'
          side: ''
          user: Auth.getUser()
        $scope.issue.save()
  $scope.completeIssue = (issue) ->
    $http.get '/api/complete/' + issue.item._id
    .then (res) ->
      if res.data is 'OK'
        alert.log 'Issue Completed' 
  $scope.uploadFiles = (files, errFiles) ->
    myissue = $scope.issue
    if files
      Upload.upload
        url: '/api/upload'
        data:
          file: files
          user: Auth.getUser()
      .then (response) ->
        if response.data
          $scope.uploadProgress = 0
          if not myissue.item.documents
            myissue.item.documents = []
          for document in response.data
            myissue.item.documents.push document
          alert.log 'Document uploaded'
          myissue.save()
      , (err) ->
        false
      , (progress) ->
        $scope.uploadProgress = Math.min 100, parseInt(100.0 * progress.loaded / progress.total)
  $scope.makeDownloadUrl = (document) ->
    '/api/download/' + btoa "#{JSON.stringify({path:document.path,filename:document.originalFilename})}"
  $scope.saveDocument = (document) ->
    document.editing = false
    alert.log 'Document updated'
    $scope.issue.save()
  $scope.deleteDocument = (document) ->
    if $window.confirm 'Are you sure you want to delete this document?'
      $scope.issue.item.documents.splice $scope.issue.item.documents.indexOf(document), 1
      alert.log 'Document deleted'
      $scope.issue.save()
  $scope.saveFn = (cb) ->
    if $scope.issue.item.date && !$scope.editing
      $scope.modal
        template: 'issue-book'
        controller: 'IssueBookCtrl'
        size: 'small'
      .then (cfpJobNumber) ->
        $scope.issue.item.cfpJobNumber = cfpJobNumber
        $scope.issue.item.isBooked = true
        alert.log 'Issue Booked'
        cb true
      , (err) ->
        cb false
    else
      $scope.issue.item.date = $scope.issue.item.date or new Date().valueOf()
      cb true