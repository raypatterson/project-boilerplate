#!/usr/bin/env ruby

require './lib/modules/load'
require './lib/modules/aws'

module Social

  include Load

  path = File.expand_path "." + "/data/project/social"

  @@social = Load.yaml path

  def self.get_title
    @@social[ 'title' ]
  end

  def self.get_description
    @@social[ 'description' ]
  end

  def self.get_share_icon
    @@social[ 'share_icon' ]
  end

  def self.get_twitter_id
    @@social[ 'twitter' ][ 'id' ]
  end

  def self.get_twitter_description
    @@social[ 'twitter' ][ 'description' ]
  end

  def self.get_twitter_hashtags
    @@social[ 'twitter' ][ 'hashtags' ]
  end
  
end