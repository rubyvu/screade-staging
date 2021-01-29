#!/usr/bin/env bash

# # Getting the environment variables
# values=$(/opt/elasticbeanstalk/bin/get-config environment)
#
# # Parsing the json and exporting them as environment variables
# for env in $(echo $values | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
#   export $env
# done
#
# EB_APP_STAGING_DIR=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppStagingDir)
# WR=$(command which ruby)
# cd $EB_APP_STAGING_DIR
# echo "Current folder $EB_APP_STAGING_DIR"
# echo "Ruby v $WR"
# echo "======"
# echo "Installing compatible bundler $env"
# gem install bundler -v 2.1.4
