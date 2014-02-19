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
npm i
npm i -g bower grunt-cli
bower i
gem i bundler
rm -rf Gemfile.lock
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