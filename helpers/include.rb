def site_title( page_name = nil )
  page_name == nil ? Site.get_title : "#{page_name} | #{Site.get_title}"
end

def favicon_image( href, rel, sizes = nil )
  tag :link, :rel => rel, :sizes => sizes, :href => "#{cache_dir}/#{href}"
end

def share_image
  "http:#{AWS.cloudfront_url( environment_type )}/#{images_dir}#{data.site.social.image}"
end

def is_production
  environment_type == Cfg.get_production_env
end