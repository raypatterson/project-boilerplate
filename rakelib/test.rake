#!/usr/bin/env ruby

require './lib/modules/aws'
require './lib/modules/site'
require './lib/modules/config'
require './lib/modules/version'
require './lib/modules/deployment'

namespace :test do

  desc "Test : Performance"
  task :performance, [:env] do | t, args |

    env = args.env || ENV[ 'ENVIRONMENT' ] || Cfg.get_development_env

    ENV[ 'SITE_URL' ] = Site.get_url env
    ENV[ 'REPORTS_S3_BUCKET' ] = AWS.get_s3_bucket "reports"
    ENV[ 'REPORTS_S3_REGION' ] = AWS.get_s3_region "reports"

    sh %{grunt performance}

  end

end