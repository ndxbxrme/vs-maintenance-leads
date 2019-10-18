superagent = require 'superagent'

module.exports = (ndx) ->
  ndx.database.on 'ready', ->
    issuesUrl = process.env.FIXFLOW_ISSUES_URL
    index = []
    sleep = (time) ->
      new Promise (resolve) ->
        setTimeout resolve, time
    fetch = (url) ->
      new Promise (resolve, reject) ->
        superagent.get url
        .set 'Authorization', 'Bearer ' + process.env.FIXFLOW_KEY
        .set 'Accept', 'application/json'
        .end (err, res) ->
          if err
            reject err
          else
            resolve res.body if res.body 
            reject {} if not res.body
    fetchAllProps = ->
      console.log 'fetch all props'
      fetchProps = (url) ->
        console.log 'fetch props', url
        index = await fetch url
        await sleep 200
        if index.Items and index.Items.length
          for item in index.Items
            console.log 'fetching', item
            prop = await fetch item
            if prop
              issue =
                address1: prop.Address.AddressLine1
                address2: prop.Address.AddressLine2 or prop.Address.Town
                postcode: prop.Address.PostCode
                media: if prop.Media and prop.Media.length then prop.Media else null
                tenantTitle: prop.Salutation
                tenantFirstName: prop.Firstname
                tenantLastName: prop.Surname
                tenantEmailAddress: prop.EmailAddress
                tenantPhone: prop.ContactNumber
                title: prop.Title or prop.FaultTitle
                description: prop.FaultNotes
                source: 'fixflo'
                date: new Date(prop.Created).valueOf()
                fixfloId: prop.Id
                fixfloUrl: item
              await ndx.database.upsert 'issues', issue, fixfloId: issue.fixfloId
              console.log 'fetched', issue.address1
            await sleep 200
        await fetchProps index.NextURL if index.NextURL
      fetchProps issuesUrl
    #fetchAllProps()