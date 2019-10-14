'use strict'

angular.module 'ndx'
.factory 'DbItem', ($http, $filter, $rootScope, $timeout) ->
  cache = {}
  index = [
    table: 'user'
    keys:
      insertedBy: true
      modifiedBy: true
      impersonatedBy: true
      authorisationUser: true
      approvalUser: true
      user: true
      userId: true
      for: true
    toString: ->
      if @.local
        @.local.email
      else
        ''
    toLink: ->
      "/users/" + @._id
  ,
    table: 'company' 
    keys:
      company: true
    toString: ->
      @.name
    toLink: ->
      "/company/" + @._id
  ,
    table: 'agency'
    keys:
      agency: true
    toString: ->
      @.name
    toLink: ->
      "/agency/" + @._id
  ,
    table: 'contractors'
    keys:
      contractors: true
    toString: ->
      @.name
    toLink: ->
      "/contractors/" + @._id
  ,
    table: 'worker'
    keys:
      worker: true
    toString: ->
      @.firstName + " " + @.lastName
    toLink: ->
      "/worker/" + @._id
  ]
  get = (key, data, asObject, cb) ->
    console.log 'me got called'
    if key and data
      type = Object.prototype.toString.call data
      if type is '[object Object]'
        mydata = JSON.parse JSON.stringify data
        for key of mydata
          mydata[key] = get key, mydata[key]
        if asObject
          cb?()
          return mydata
        cb?()
        return JSON.stringify mydata, null, '  '
      else if type is '[object Array]'
        output = ''
        for item in data
          output += get 'array', item
        cb?()
        return output
      else if /^\d{13}$/.test data.toString()
        if data.toString() is '9999999999999'
          return ''
        return $filter('date')(data, $rootScope.mediumDate)
      else if /^[\da-z]{24}$/.test data.toString()
        if cache[data]
          cb? cache[data]
          return cache[data]
        cache[data] = data
        for table in index
          if table.keys[key]
            $http.get "/api/" + table.table + "/" + data
            .then (res) ->
              cache[data] = res.data
              cache[data].toString = table.toString
              cache[data].toLink = table.toLink
              cb? cache[data]
            , (err) ->
              false
            break
        return ''
      else
        cb?()
        return data
  getEntity = (table, item) ->
    if item and id = (item[table] or item.assignmentDetails?[table])
      if cache[id]
        return cache[id]
      cache[id] = {}
      $http.get "/api/" + table + "/" + id + "/all"
      .then (res) ->
        cache[id] = res.data
      , (err) ->
        false
    return {}
  getObject = (table, id, obj, fieldsToClone, cb) ->
    fillObject = (val) ->
      if fieldsToClone
        if typeof fieldsToClone is 'string'
          obj[fieldsToClone] = val
        else
          for field of fieldsToClone
            obj[field] = val[fieldsToClone[field]]
    if cache[id] and JSON.stringify(cache[id]) isnt '{}'
      fillObject cache[id]
      return cb?()
    cache[id] = {}
    $http.get "/api/" + table + "/" + id + "/all"
    .then (res) ->
      cache[id] = res.data
      fillObject res.data
      cb?()
    , (err) ->
      false
      
  get: get
  getEntity: getEntity
  getObject: getObject
  getText: (key, data) ->
  clearCache: ->
    cache = {}
    