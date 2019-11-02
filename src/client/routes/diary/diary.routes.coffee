'use strict'

angular.module 'vs-maintenance-leads'
.config ($stateProvider) ->
  $stateProvider.state 'diary',
    url: '/diary/:_id'
    templateUrl: 'routes/diary/diary.html'
    controller: 'DiaryCtrl'
    data:
      title: 'Vitalspace Mainenance Leads - Diary'
      auth: ['superadmin','admin','agency']