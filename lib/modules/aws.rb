#!/usr/bin/env ruby

require './lib/modules/load'

module AWS

  include Load

  path = File.expand_path "." + "/data/project"

  @@aws = Load.yaml "#{path}/aws"

  def self.access_key
    ENV['S3_ACCESS_KEY_ID']
  end

  def self.secret_key
    ENV['S3_SECRET_KEY_ID']
  end

  def self.region( env )
    @@aws[ env ][ "region" ]
  end

  def self.bucket( env )
    @@aws[ env ][ "bucket" ]
  end

  def self.eb_name
    @@aws[ "elasticbeanstalk" ][ "name" ]
  end

  def self.eb_region
    @@aws[ "elasticbeanstalk" ][ "region" ]
  end

  def self.eb_stack
    @@aws[ "elasticbeanstalk" ][ "stack" ]
  end

  def self.eb_env( env )
    @@aws[ env ][ "elasticbeanstalk" ]
  end

  def self.cloudfront_url( env )
    "//#{@@aws[ env ][ "subdomain" ]}.cloudfront.net"
  end

  def self.cloudfront_distribution_id( env )
    @@aws[ env ].distribution_id
  end

end