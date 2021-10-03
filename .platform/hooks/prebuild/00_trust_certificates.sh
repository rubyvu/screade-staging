#!/usr/bin/env bash

if rpm -q ca-certificates-2021.2.50-72.amzn2.0.1.noarch
then
  echo 'ca-certificates-2021.2.50-72.amzn2.0.1 is already installed!'
else
  sudo yum install -y https://cdn.amazonlinux.com/patch/ca-certificates-update-2021-09-30/ca-certificates-2021.2.50-72.amzn2.0.1.noarch.rpm
fi
