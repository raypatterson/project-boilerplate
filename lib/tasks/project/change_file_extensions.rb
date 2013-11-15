#!/usr/bin/env ruby

require 'fileutils'

namespace :project do

  # Project Utils
  namespace :utils do

    desc "Change File Extensions"
    task :change_file_extensions, [ :target, :extension_from, :extension_to ] do | t, args |

      files = Dir.glob "#{args.target}*.#{args.extension_from}"

      files.each do | f |

        FileUtils.mv f, "#{File.dirname( f )}/#{File.basename( f, '.*' )}.#{args.extension_to}"
        
      end
      
    end

  end

end
