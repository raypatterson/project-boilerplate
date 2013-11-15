#!/usr/bin/env ruby

require 'fileutils'
require 'nokogiri'

namespace :project do

  # Project Utils
  namespace :utils do

    desc "Copy Files"
    task :copy_files, [ :source, :target, :file_names ] do | t, args |

      list = [] 

      args.file_names.each do | f |

        list.push "#{args.source}#{f}"
        
      end

      FileUtils.cp_r list, args.target, :verbose => true

    end

  end

end
