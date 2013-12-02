#!/usr/bin/env ruby

require 'fileutils'
require 'nokogiri'

namespace :project do

  # Project Utils
  namespace :utils do

    desc "Inject CSRF Helper"
    task :inject_csrf_helper, [ :target ] do | t, args |

      

      # # Build files
      # if File.exists? origin
      #   FileUtils.rm_rf origin
      # end

      # # Get index markup
      # index = origin + "/index.html"
      # f = File.open index
      # doc = Nokogiri::HTML.parse f
      # f.close()
      # File.delete index

      # # Write token helper into markup
      # head = doc.at_css "head"
      # s1 = 'csrf_meta_tag'
      # r1 = "<%= #{s1} %>"
      # head << s1
      # # Write A/B test id into markup
      # s2 = 'ab_test_id'
      # r2 = "<script type=\"text/javascript\">window.__#{s2}__ = \"<%= @form_type %>\";</script>"
      # head << s2

      # markup = doc.to_s
      
      # markup = markup.gsub s1, r1
      # markup = markup.gsub s2, r2
      
      # Prefix file routes
      # markup = markup.gsub(/="(\/?images.+?\>|\/?stylesheets.+?\>|\/?javascripts.+?\>)/, '="b/\1')


      # Write to view
      # view = "#{destination}/index.html"

      # if File.exists? view
      #   FileUtils.rm_rf view
      # end

      # File.open( view, 'w' ) { |f| f.write( markup ) }

      # if File.exists? target
      #   FileUtils.rm_rf target
      # end

      # FileUtils.cp_r source, target

      # FileUtils.rm_rf origin
    end

  end

end
