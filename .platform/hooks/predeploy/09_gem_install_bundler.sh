#!/usr/bin/env bash
EB_APP_STAGING_DIR=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppStagingDir)

cd $EB_APP_STAGING_DIR
echo "Current folder $EB_APP_STAGING_DIR"
echo "Installing compatible bundler"
# gem install bundler -v 2.1.4
