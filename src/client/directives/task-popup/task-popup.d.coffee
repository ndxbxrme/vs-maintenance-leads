'use strict'

angular.module 'vs-maintenance-leads'
.directive 'taskPopup', ($http, alert, TaskPopup) ->
  restrict: 'EA'
  templateUrl: 'directives/task-popup/task-popup.html'
  replace: true
  link: (scope, elem, attrs) ->
    scope.getTask = TaskPopup.getTask
    scope.getHidden = TaskPopup.getHidden
    scope.getDateTo = ->
      task = TaskPopup.getTask()
      if task
        new Date(task.date.valueOf() + task.duration.valueOf())
    scope.chaseContractor = (method, task) ->
      $http.get '/api/chase/' + method + '/' + scope.getTask()._id
      .then (res) ->
        if res.data is 'OK'
          alert.log 'Contractor chased' 
    scope.informTenant = (method, task) ->
      $http.get '/api/inform/' + method + '/' + scope.getTask()._id
      .then (res) ->
        if res.data is 'OK'
          alert.log 'Tenant informed' 
    scope.save = ->
      if not TaskPopup.getHidden() and scope.getTask()
        $http.post "/api/tasks/#{scope.getTask()._id or ''}", scope.getTask()
        .then (response) ->
          alert.log 'Task updated'
        , (err) ->
          false
    scope.complete = ->
      scope.getTask().status = 'completed'
      scope.save()
    scope.edit = (task) ->
      TaskPopup.hide()
      scope.modal
        template: 'task'
        controller: 'TaskCtrl'
        data: 
          task: task
          maintenance: scope.maintenance
          contractors: TaskPopup.getContractors()
      .then (response) ->
        true
      , (err) ->
        false