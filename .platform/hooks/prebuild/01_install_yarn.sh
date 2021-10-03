#!/usr/bin/env bash
set -xe

echo "Installing Node JS..."
curl --silent --location https://rpm.nodesource.com/setup_14.x | sudo bash -
yum -y install nodejs

if yarn -v; then
  echo "Yarn is already installed."
else
  echo "Installing Yarn..."
  wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
  yum -y install yarn
fi
