require "./lib/modules/config"
require "./lib/modules/deployment"
require "./lib/modules/social"
require "./lib/modules/site"
require "./lib/modules/aws"
require "./lib/extensions/aws_cloudfront_invalidate"
require "./lib/extensions/github_pages_deploy"

require "handlebars_assets"
require "sass-globbing"
require "semantic-ui-sass"
require "susy"

# Config #
##########

Middleman::Extensions.register(:aws_cloudfront_invalidate, AwsCloudfrontInvalidate)
Middleman::Extensions.register(:github_pages_deploy, GitHubPagesDeploy)

HandlebarsAssets::Config.template_namespace = "JST"

activate :livereload
activate :directory_indexes
activate :clowncar

set :environment_type, ENV[ "ENVIRONMENT" ] || Cfg.get_localhost_env
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

set :host, "localhost:8888"

set :relative_assets, true

if ENV['CI'] == true
  set :build_dir, "deploy"
else
  set :build_dir, "build"
end

set :asset_dir, "assets"
set :watch_dir, "#{asset_dir}/watch"
set :js_dir, "#{asset_dir}"
set :css_dir, "#{asset_dir}"
set :data_dir, "#{asset_dir}/data"
set :fonts_dir, "#{asset_dir}/fonts"
set :images_dir, "#{asset_dir}/images"
set :cache_dir, "#{images_dir}/cache"
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

# Build #
#########

activate :deploy do | deploy |
  deploy.method = :git
end

configure :build do

  activate :relative_assets

  activate :favicon_maker, {
    :favicon_maker_input_dir => "#{source}/#{cache_dir}",
    :favicon_maker_output_dir => "#{build_dir}/#{cache_dir}"
  }

  activate :asset_hash, {:ignore => [ "#{cache_dir}/*" ] }
  # activate :asset_hash, {:ignore => [ "#{source}/#{cache_dir}/**/*" ] }

  activate :minify_css
  activate :minify_javascript
  activate :minify_html

  activate :gzip
  # activate :gzip, { :exts => [ ".css", ".js" ] }

  activate :image_optim do | image_optim |
    # print out skipped images
    image_optim.verbose = false

    # Setting these to true or nil will let image_optim determine them (recommended)
    image_optim.nice = true
    image_optim.threads = true

    # Image extensions to attempt to compress
    image_optim.image_extensions = %w(.png .jpg .gif)

    # compressor worker options, individual optimisers can be disabled by passing
    # false instead of a hash
    image_optim.pngcrush_options  = {:chunks => ["alla"], :fix => false, :brute => false}
    image_optim.pngout_options    = {:copy_chunks => false, :strategy => 0}
    image_optim.optipng_options   = {:level => 6, :interlace => false}
    image_optim.advpng_options    = {:level => 4}
    image_optim.jpegoptim_options = {:strip => ["all"], :max_quality => 100}
    image_optim.jpegtran_options  = {:copy_chunks => false, :progressive => true, :jpegrescan => true}
    image_optim.gifsicle_options  = {:interlace => false}
  end

  if deploy_active == true

    if deploy_target == Deployment.TARGET_AWS

      activate :s3_sync do | s3_sync |
        s3_sync.bucket = AWS.bucket environment_type # The name of the S3 bucket you are targetting. This is globally unique.
        s3_sync.region = AWS.region environment_type # The AWS region for your bucket.
        s3_sync.aws_access_key_id = AWS.access_key
        s3_sync.aws_secret_access_key = AWS.secret_key
        s3_sync.delete = true # We delete stray files by default.
        s3_sync.after_build = true # We chain after the build step by default. This may not be your desired behavior...
      end

      # Invalidate CloudFront
      activate :aws_cloudfront_invalidate do | invalidator |
        invalidator.access_key = AWS.access_key
        invalidator.secret_key = AWS.secret_key
        invalidator.distribution_id = AWS.distribution_id environment_type
      end

    elsif deploy_target == Deployment.TARGET_GITHUB_PAGES

      activate :github_pages_deploy

    else

      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      puts "Unknown Deploy Target: #{deploy_target}"
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

    end

  end

end