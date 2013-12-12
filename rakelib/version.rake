#!/usr/bin/env ruby

require './lib/modules/version'

namespace :version do

  desc "Version : Increment"
  task :increment do
    Version.increment_build_version()
  end
  
  desc "Version : Tag"
  task :tag do
    Version.tag_build()
  end
  
end
