#!/bin/sh
echo '.'
echo '.'
echo '.'
echo '. . . Welcome'
echo '.'
echo '.'
echo '.'
echo '. . . Updating'
echo '.'
echo '.'
echo '.'
brew update
echo '.'
echo '.'
echo '.'
echo '. . . Installing'
echo '.'
echo '.'
echo '.'
brew install advancecomp gifsicle jhead jpegoptim jpeg optipng pngcrush
npm install
npm install -g grunt-cli
npm install -g bower
bower install
gem install bundler
rm -f Gemfile.lock
bundle install
echo '.'
echo '.'
echo '.'
echo '. . . Complete'
echo '.'
echo '.'
echo '.'
echo '. . . Starting'
echo '.'
echo '.'
echo '.'
rake mm:s