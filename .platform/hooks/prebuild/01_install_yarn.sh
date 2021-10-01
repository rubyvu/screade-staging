#!/bin/bash

# Install NVM if it is not installed yet
if nvm -v; then
  echo "NVM is already installed."
else
  echo "Installing NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
  source ~/.bashrc
fi

read node_version _ <<< $(node -v)
if [ "$node_version" == "v14.18.0" ]; then
  echo "Node is already installed."
else
  echo "Installing NodeJS..."
  nvm install 14.18.0
  nvm alias default 14.18.0
fi

# Install Yarn if it is not installed yet
if yarn -v; then
  echo "Yarn is already installed."
else
  echo "Installing Yarn..."
  npm install --global yarn
fi
