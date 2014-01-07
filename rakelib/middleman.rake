#!/usr/bin/env ruby

require './lib/modules/aws'
require './lib/modules/site'
require './lib/modules/config'
require './lib/modules/version'
require './lib/modules/deployment'

namespace :mm do

  desc "Middleman : Start Local Server"
  task :s, [ :port ] do | t, args |

    port = args.port || Cfg.get_localport

    ENV[ 'ENVIRONMENT' ] = Cfg.get_localhost_env

    sh %{middleman server -p #{port}}

  end

  # Build Tasks
  namespace :build do

    desc "Middleman : Build : DEVELOPMENT"
    task :development, [:deploy, :increment, :tag, :message] do | t, args |

      build Cfg.get_development_env, args

    end

    desc "Middleman : Build : REVIEW"
    task :review, [:deploy, :increment, :tag, :message] do | t, args |

      build Cfg.get_review_env, args

    end

    desc "Middleman : Build : STAGING"
    task :staging, [:deploy, :increment, :tag, :message] do | t, args |

      build Cfg.get_staging_env, args

    end

    desc "Middleman : Build : PRODUCTION"
    task :production, [:deploy, :increment, :tag, :message] do | t, args |

      build Cfg.get_production_env, args

    end

  end

end

def build( env, args )

  ENV[ 'ENVIRONMENT' ] = env

  # Deploy

  deploy = ( args.deploy || Deployment.get_active( env ) ) == true ? 'true' : 'false'

  # puts "Deploy: #{deploy}"

  ENV[ 'DEPLOY' ] = deploy

  # Increment

  increment = args.increment || Deployment.get_increment( env ) || false

  # puts "Increment: #{increment}"

  if increment == true
    Version.increment_build_version
  end

  tag = args.tag || Deployment.get_tag( env ) || false

  # puts "Tag: #{tag}"

  message = args.message || Deployment.get_message( env ) || nil

  # puts "Message: #{message}"

  if tag == true
    Version.tag_build message
  end

  sh %{middleman build}

  ENV[ 'SITE_URL' ] = Site.get_url env
  ENV[ 'S3_BUCKET' ] = AWS.get_bucket "reports"
  ENV[ 'S3_REGION' ] = AWS.get_region "reports"

  sh %{grunt performance}

end