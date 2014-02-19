#!/usr/bin/env ruby

require "./lib/modules/load"

module Site

  include Load

  path = File.expand_path "." + "/data/project/site"

  @@site = Load.yaml path

  def self.get_namespace
    @@site[ "namespace" ]
  end

  def self.get_id
    @@site[ "id" ]
  end

  def self.get_name
    @@site[ "name" ]
  end

  def self.get_title
    @@site[ "title" ]
  end

  def self.get_description
    @@site[ "description" ]
  end

  def self.get_keywords
    @@site[ "get_keywords" ]
  end

  def self.get_url( env )
    @@site[ "url" ][ env ]
  end

end