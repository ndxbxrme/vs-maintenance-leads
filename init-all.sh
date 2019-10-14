#!/bin/bash
git pull
npm install
npm install -g grunt-cli
bower install
grunt build
#groupadd -r vsmaintenanceleads && useradd -m -r -g vsmaintenanceleads vsmaintenanceleads
su vsmaintenanceleads -c ". env.sh
screen -X -S VSMAINTENANCELEADS quit || true
screen -S VSMAINTENANCELEADS node --expose-gc server/app.js"
