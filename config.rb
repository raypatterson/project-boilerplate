require "./lib/modules/config"
require "./lib/modules/deployment"
require "./lib/modules/social"
require "./lib/modules/site"
require "./lib/modules/aws"
require "./lib/extensions/deploy/github"
require "./lib/extensions/deploy/aws"
require "./lib/extensions/deploy/headers"

require "builder"
require "uglifier"
require "handlebars_assets"
require "sass-globbing"

# Config #
##########

page "/sitemap.xml", :layout => false
page "/page/*", :layout => "page"

::Middleman::Extensions.register :deploy_github, DeployGitHub
::Middleman::Extensions.register :deploy_aws, DeployAws
::Middleman::Extensions.register :deploy_headers, DeployHeaders

::HandlebarsAssets::Config.template_namespace = "JST"

set :environment_type, ENV[ "ENVIRONMENT" ] || Cfg.get_localhost_env

set :protect_from_csrf, true

set :deploy_active, Deployment.get_active( environment_type ) || false
set :deploy_target, Deployment.get_target( environment_type )

set :build_version, Cfg.get_build_version
set :debug_flag, Cfg.get_debug_flag( environment_type )

set :site_namespace, Site.get_namespace
set :site_name, Site.get_name
set :site_description, Site.get_description
set :site_keywords, Site.get_keywords
set :site_url, Site.get_url( environment_type )

# Paths #
#########

set :relative_assets, true

set :build_dir, "build"
set :asset_dir, "assets"
set :watch_dir, "#{asset_dir}/watch"
set :js_dir, "#{asset_dir}"
set :css_dir, "#{asset_dir}"
set :data_dir, "#{asset_dir}/data"
set :fonts_dir, "#{asset_dir}/fonts"
set :images_dir, "#{asset_dir}/images"
set :cache_dir, "#{asset_dir}/cache"
set :clowncar_dir, "#{images_dir}/clowncar"
set :partials_dir, "#{watch_dir}"

ignore "#{watch_dir}/**/*"

# Add bower's directory to Sprockets and Compass asset path
set :bower_dir, ( File.join "#{root}", JSON.parse( IO.read( "#{root}/.bowerrc" ) )[ "directory" ] )

after_configuration do
  sprockets.append_path bower_dir
  sprockets.append_path watch_dir
end

compass_config do | config |
  config.add_import_path bower_dir
  config.add_import_path watch_dir
end

# Activate #
############

if environment_type == Cfg.get_localhost_env
  activate :livereload
end

activate :dotenv, :env => ".env-#{environment_type}"

activate :autoprefixer
activate :directory_indexes
activate :automatic_image_sizes # Automatic image dimensions on image_tag helper
activate :clowncar

# Development #
###############

configure :development do
  set :debug_assets, true
end

# Build #
#########

configure :build do

  activate :relative_assets

  activate :favicon_maker do | favicon_maker |
    favicon_maker.template_dir = "#{source}/#{cache_dir}"
    favicon_maker.output_dir = "#{build_dir}/#{cache_dir}"
    favicon_maker.icons = {
      "favicon_base.png" => [
        { icon: "apple-touch-icon-152x152-precomposed.png" },
        { icon: "apple-touch-icon-144x144-precomposed.png" },
        { icon: "apple-touch-icon-120x120-precomposed.png" },
        { icon: "apple-touch-icon-114x114-precomposed.png" },
        { icon: "apple-touch-icon-76x76-precomposed.png" },
        { icon: "apple-touch-icon-72x72-precomposed.png" },
        { icon: "apple-touch-icon-60x60-precomposed.png" },
        { icon: "apple-touch-icon-57x57-precomposed.png" },
        { icon: "apple-touch-icon-precomposed.png", size: "57x57" },
        { icon: "apple-touch-icon.png", size: "57x57" },
        { icon: "favicon-196x196.png" },
        { icon: "favicon-160x160.png" },
        { icon: "favicon-96x96.png" },
        { icon: "favicon-32x32.png" },
        { icon: "favicon-16x16.png" },
        { icon: "favicon.png", size: "16x16" },
        { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },
        { icon: "mstile-144x144", format: "png" },
      ]
    }
  end

  activate :asset_hash, {:ignore => [ "#{cache_dir}/*" ] }

  activate :minify_javascript, {
    # Special condition for AngularJS
    :compressor => Uglifier.new(:mangle => false)
  }

  activate :minify_css

  activate :minify_html

  activate :gzip
  # activate :gzip, { :exts => [ ".css", ".js" ] }

  activate :imageoptim do | imageoptim |
    # print out skipped images
    imageoptim.verbose = true

    # Setting these to true or nil will let imageoptim determine them (recommended)
    imageoptim.nice = true
    imageoptim.threads = true

    # Image extensions to attempt to compress
    imageoptim.image_extensions = %w(.png .jpg .gif)

    # compressor worker options, individual optimisers can be disabled by passing false instead of a hash
    imageoptim.pngcrush_options  = {:chunks => ["alla"], :fix => false, :brute => false}
    imageoptim.pngout_options    = {:copy_chunks => false, :strategy => 0}
    imageoptim.optipng_options   = {:level => 6, :interlace => false}
    imageoptim.advpng_options    = {:level => 4}
    imageoptim.jpegoptim_options = {:strip => ["all"], :max_quality => 100}
    imageoptim.jpegtran_options  = {:copy_chunks => false, :progressive => true, :jpegrescan => true}
    imageoptim.gifsicle_options  = {:interlace => false}
  end

  if deploy_active == true

    if deploy_target == Deployment.TARGET_AWS

      activate :deploy_aws
      activate :deploy_headers

    elsif deploy_target == Deployment.TARGET_GITHUB_PAGES

      activate :deploy_github

    else

      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts "Unknown Deploy Target: #{deploy_target}"
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

    end

  end

end

# Deploy #
##########

activate :deploy do | deploy |
  deploy.method = :git
end

activate :s3_sync do | s3_sync |
  s3_sync.bucket = AWS.bucket environment_type
  s3_sync.region = AWS.region environment_type
  s3_sync.aws_access_key_id = AWS.access_key
  s3_sync.aws_secret_access_key = AWS.secret_key
  s3_sync.delete = true # We delete stray files by default.
  s3_sync.prefer_gzip = true
end

max_age = 60 * 60 * 24 * 365
default_caching_policy({
  :max_age => max_age,
  :s_maxage => max_age,
  :public => true,
  :no_cache => false,
  :no_store => false,
  :must_revalidate => false,
  :proxy_revalidate => false
})

activate :s3_metadata do | s3_metadata |
  s3_metadata.bucket = AWS.bucket environment_type
  s3_metadata.region = AWS.region environment_type
  s3_metadata.aws_access_key_id = AWS.access_key
  s3_metadata.aws_secret_access_key = AWS.secret_key
end

activate :cloudfront do | cloudfront |
  cloudfront.access_key_id = AWS.access_key
  cloudfront.secret_access_key = AWS.secret_key
  cloudfront.distribution_id = AWS.cloudfront_distribution_id environment_type
  cloudfront.filter = /\.html$/i
end