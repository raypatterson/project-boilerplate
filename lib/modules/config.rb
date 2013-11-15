#!/usr/bin/env ruby

require 'securerandom'
require './lib/modules/load'
require './lib/modules/site'
require './lib/modules/version'

module Cfg

  include Load
  include Version

  path = File.expand_path "." + "/data/configs"

  @@defaults = Load.yaml "#{path}/default"
  @@env = Load.yaml "#{path}/environment"
  @@debug = Load.yaml "#{path}/debug"

  def self.get_build_version
    Version.get_version()
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
    @@env[ 'localhost' ]
  end

  def self.get_development_env
    @@env[ 'development' ]
  end

  def self.get_review_env
    @@env[ 'review' ]
  end

  def self.get_staging_env
    @@env[ 'staging' ]
  end

  def self.get_production_env
    @@env[ 'production' ]
  end

end