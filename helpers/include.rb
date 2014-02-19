def site_title( page_name = nil )
  page_name == nil ? Site.get_title : "#{page_name} | #{Site.get_title}"
end

def favicon_image( href, rel, sizes = nil )
  tag :link, :rel => rel, :sizes => sizes, :href => "#{cache_dir}/#{href}"
end

def clowncar_image( dir )
  "<div class=\"image-clowncar\">" + ( clowncar_tag dir, :host => site_url, :fallback => "small.png" ) + "</div>"
end

def share_icon
  "http:#{AWS.cloudfront_url( environment_type )}/#{images_dir}#{Social.get_share_icon}"
end

def is_production
  environment_type == Cfg.get_production_env
end

def javascript_inline_tag( filename )

  s = IO.read( "#{source_dir}/#{watch_dir}/#{filename}.js" )

  "<script type=\"text/javascript\">
    // <![CDATA[
#{s}
    // ]]>
  </script>"
end