#!/usr/bin/env ruby

require 'securerandom'
require './lib/modules/load'
require './lib/modules/site'
require './lib/modules/version'

module Cfg

  include Load
  include Version

  path = File.expand_path "." + "/data/core"

  @@debug = Load.yaml "#{path}/debug"
  @@defaults = Load.yaml "#{path}/default"
  @@environment = Load.yaml "#{path}/environment"

  def self.get_build_version
    ENV['TRAVIS_BUILD_NUMBER'] || Version.get_version()
  end

  def self.get_cache_buster
    "?#{self.get_build_version}-#{SecureRandom.hex 10}"
  end

  def self.get_debug_flag( env )
    @@debug[ env ] || @@defaults[ 'debug' ] || true
  end

  def self.get_localport
    @@defaults[ 'localport' ]
  end

  def self.get_localhost_env
    @@environment[ 'localhost' ]
  end

  def self.get_development_env
    @@environment[ 'development' ]
  end

  def self.get_review_env
    @@environment[ 'review' ]
  end

  def self.get_staging_env
    @@environment[ 'staging' ]
  end

  def self.get_production_env
    @@environment[ 'production' ]
  end

end