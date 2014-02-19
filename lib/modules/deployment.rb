#!/usr/bin/env ruby

require "./lib/modules/load"

module Deployment

  include Load

  path = File.expand_path "." + "/data/project"

  @@doc = Load.yaml "#{path}/deployment"

  def self.TARGET_AWS
    @@doc[ "targets" ][ "aws" ]
  end

  def self.TARGET_GITHUB_PAGES
    @@doc[ "targets" ][ "github_pages" ]
  end

  def self.TARGET_HEROKU
    @@doc[ "targets" ][ "heroku" ]
  end

  def self.get_active( env )
    @@doc[ "environments" ][ env ][ "active" ]
  end

  def self.get_target( env )
    @@doc[ "environments" ][ env ][ "target" ]
  end

  def self.get_increment( env )
    @@doc[ "environments" ][ env ][ "increment" ]
  end

  def self.get_tag( env )
    @@doc[ "environments" ][ env ][ "tag" ]
  end

  def self.get_message( env )
    @@doc[ "environments" ][ env ][ "message" ]
  end

end