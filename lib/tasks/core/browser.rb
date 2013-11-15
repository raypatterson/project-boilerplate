#!/usr/bin/env ruby

require './lib/modules/config'

namespace :browser do

  url = "http://localhost:#{Cfg.get_localport}"

  desc "Browser : Open Chrome"
  task :chrome do
    sh %{open /Applications/Google\*Chrome.app #{url}}
  end
  
  desc "Browser : Open Firefox"
  task :firefox do
    sh %{open -a Firefox #{url}}
  end
  
  desc "Browser : Open Safari"
  task :safari do
    sh %{open -a Safari #{url}}
  end

  desc "Browser : Open Safari"
  task :all do
    Rake::Task[ 'browser:chrome' ].invoke
    Rake::Task[ 'browser:firefox' ].invoke
    Rake::Task[ 'browser:safari' ].invoke
  end
end