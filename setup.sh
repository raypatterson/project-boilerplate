#!/bin/sh
echo 'Setting up project...'
echo '.'
echo '.'
echo '.'
echo 'This is good time to get a coffee.'
echo '.'
echo '.'
echo '.'
bower install
gem install bundler
bundle install
echo '.'
echo '.'
echo '.'
echo 'Project setup complete!'
echo 'Starting server...'
echo '.'
echo '.'
echo '.'
rake mm:s