#!/usr/bin/env bash
# Using similar syntax as the appdeploy pre hooks that is managed by AWS
set -xe

EB_SCRIPT_DIR=$(/opt/elasticbeanstalk/bin/get-config container -k script_dir)
EB_APP_STAGING_DIR=$(/opt/elasticbeanstalk/bin/get-config container -k app_staging_dir)
EB_APP_USER=$(/opt/elasticbeanstalk/bin/get-config container -k app_user)
EB_SUPPORT_DIR=$(/opt/elasticbeanstalk/bin/get-config container -k support_dir)

. $EB_SUPPORT_DIR/envvars

RAKE_TASK="db:seed"

. $EB_SCRIPT_DIR/use-app-ruby.sh

cd $EB_APP_STAGING_DIR

if su -s /bin/bash -c "bundle exec $EB_SCRIPT_DIR/check-for-rake-task.rb $RAKE_TASK" $EB_APP_USER; then
  su -s /bin/bash -c "leader_only bundle exec rake db:seed" $EB_APP_USER
else
  echo "No $RAKE_TASK task in Rakefile, skipping database seed."
fi
