'use strict'

require 'ndx-server'
.config
  database: 'db'
  tables: ['users', 'issues', 'contractors', 'emailtemplates', 'smstemplates']
  localStorage: './data'
.start()
