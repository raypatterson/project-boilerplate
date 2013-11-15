require "./lib/modules/config"
require './lib/modules/site'
require './lib/modules/aws'
require "./lib/extensions/invalidator"

# Config #
##########

$env = ENV[ 'ENVIRONMENT' ] || Cfg.get_localhost_env
$deploy = ENV[ 'DEPLOY' ] || false

# Add bower's directory to sprockets asset path
after_configuration do
  
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join "#{root}", @bower_config["directory"]

end

activate :livereload

# Paths #
#########

@asset_path = "assets/"

set :images_dir, "#{@asset_path}img"
set :css_dir, "#{@asset_path}css"
set :js_dir, "#{@asset_path}js"
set :fonts_dir, "#{@asset_path}font"

set :build_dir, "build"

@cache_path = "#{images_dir}/cache"

# Ignore #
##########

ignore "app/**/*"
ignore "#{@asset_path}js/**/*"
ignore "#{@asset_path}css/**/*"

# Helpers #
###########

helpers do
  def environment_type
    $env
  end
  def build_version
    Cfg.get_build_version
  end
  def debug_flag
    Cfg.get_debug_flag $env
  end
  def site_namespace
    Site.get_namespace
  end
  def site_title
    Site.get_title
  end
  def site_name
    Site.get_name
  end
  def site_description
    Site.get_description
  end
  def site_keywords
    Site.get_keywords
  end
  def site_url
    Site.get_url $env
  end
  def asset_dir
    @asset_path
  end
  def cache_path
    "#{@cache_path}/"
  end
  def favicon_image( href, rel, sizes = nil )
    tag :link, :rel => rel, :sizes => sizes, :href => "#{cache_path}/#{href}"
  end
  def share_image
    "http:#{AWS.cloudfront_url( $env )}/#{@images_dir}#{data.site.social.image}"
  end
end

# Build #
#########

configure :build do

  activate :relative_assets

  activate :favicon_maker, {
    :favicon_maker_input_dir => "#{source}/#{@cache_path}",
    :favicon_maker_output_dir => "#{build_dir}/#{@cache_path}"
  }

  activate :asset_hash, {:ignore => [ "#{@cache_path}/*" ] }
  
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

  if $deploy != false

    activate :s3_sync do | s3_sync |
      s3_sync.bucket = AWS.bucket $env # The name of the S3 bucket you are targetting. This is globally unique.
      s3_sync.region = AWS.region $env # The AWS region for your bucket.
      s3_sync.aws_access_key_id = AWS.access_key
      s3_sync.aws_secret_access_key = AWS.secret_key
      s3_sync.delete = true # We delete stray files by default.
      s3_sync.after_build = true # We chain after the build step by default. This may not be your desired behavior...
    end

    # Invalidate CloudFront
    activate :invalidator do | invalidator |
      invalidator.access_key = AWS.access_key
      invalidator.secret_key = AWS.secret_key
      invalidator.distribution_id = AWS.distribution_id $env
    end

  end

end