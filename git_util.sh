#!/bin/bash
# function to sync the git
function sync {
  sleep $[ ( $RANDOM % 60 )  + 1 ]s
  cd /root/anthony/lelec2990-sim2
  git config user.name "Anthony Gégo"
  git config user.email "anthonygego@fakemail.com"
  git config push.default simple
  git add -A .
  git commit -a -m "sync"
  ssh-agent bash -c 'ssh-add /etinfo/users/2013/gegoa/.ssh/id_rsa; git pull --no-edit -s recursive -X theirs'
  ssh-agent bash -c 'ssh-add /etinfo/users/2013/gegoa/.ssh/id_rsa; git push'
}