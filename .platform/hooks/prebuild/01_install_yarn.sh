#!/bin/bash

# Install Node JS
echo "Installing Node JS..."
curl --silent --location https://rpm.nodesource.com/setup_14.x | sudo bash -
yum -y install nodejs

# Install Yarn if it is not installed yet
if yarn -v; then
  echo "Yarn is already installed."
else
  echo "Installing Yarn..."
  wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
  yum -y install yarn
fi
