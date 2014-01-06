#!/usr/bin/env ruby

require './lib/modules/load'

module AWS

  include Load

  path = File.expand_path "." + "/data/project"

  @@aws = Load.yaml "#{path}/aws"

  def self.get_access_key
    @@aws[ 'access_key' ]
  end

  def self.get_secret_key
    @@aws[ 'secret_key' ]
  end

  def self.get_region( env )
    @@aws[ env ][ "region" ]
  end

  def self.get_bucket( env )
    @@aws[ env ][ "bucket" ]
  end

  def self.get_eb_name
    @@aws[ "elasticbeanstalk" ][ "name" ]
  end

  def self.get_eb_region
    @@aws[ "elasticbeanstalk" ][ "region" ]
  end

  def self.get_eb_stack
    @@aws[ "elasticbeanstalk" ][ "stack" ]
  end

  def self.get_eb_env( env )
    @@aws[ env ][ "elasticbeanstalk" ]
  end

  def self.get_cloudfront_url( env )
    "//#{@@aws[ env ][ "subdomain" ]}.cloudfront.net"
  end

  def self.get_cloudfront_distribution_id( env )
    @@aws[ env ][ 'distribution_id' ]
  end

end