#!/usr/bin/env ruby

namespace :utils do

  desc "Utils : Find Process on Port"
  task :find_port, [:port] do |t, args|
    sh %{lsof -w -n -i tcp:#{args.port}}
  end
  
end