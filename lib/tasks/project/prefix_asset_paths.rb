#!/usr/bin/env ruby

require 'fileutils'
require 'nokogiri'

namespace :project do

  # Project Utils
  namespace :utils do

    desc "Prefix Asset Paths"
    task :prefix_asset_paths, [ :prefix, :file_list ] do | t, args |

      args.file_list.each do | f |

        file = File.open f
        doc = Nokogiri::HTML.parse file
        file.close()

        markup = doc.to_s

        prefix = '="' + args.prefix + '/\1'

        regex = '=\"(\/?assets\/img.+?\>|\/?assets\/css.+?\>|\/?assets\/js.+?\>|\/?assets\/html.+?\>)'

        markup = markup.gsub(/#{regex}/, "#{prefix}")

        # puts markup

        File.open( f, 'w' ) { | file | 
          file.write( markup ) 
          file.close()
        }

      end
      
    end

  end

end
