'use strict'

require 'ndx-server'
.config
  database: 'db'
  tables: ['users', 'issues', 'contractors']
  localStorage: './data'
.start()
