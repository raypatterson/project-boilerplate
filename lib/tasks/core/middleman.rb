#!/usr/bin/env ruby

require './lib/modules/site'
require './lib/modules/config'
require './lib/modules/version'

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
    task :development, [:version, :tag] do | t, args |
      build Cfg.get_development_env
    end
    
    desc "Middleman : Build : REVIEW"
    task :review, [:version, :tag] do | t, args |
      build Cfg.get_review_env
    end
    
    desc "Middleman : Build : STAGING"
    task :staging, [:version, :tag] do | t, args |
      build Cfg.get_staging_env, ( args.version || true ), ( args.tag || true ), "Staging"
    end
    
    desc "Middleman : Build : PRODUCTION"
    task :production, [:version, :tag] do | t, args |
      build Cfg.get_production_env, ( args.version || true ), ( args.tag || true ), "Production"
    end
    
  end
  
end

def build( env, increment = false, tag = false, message = nil )
  
  if increment === true
    Version.increment_build_version
  end
  
  if tag === true
    Version.tag_build message
  end
  
  ENV[ 'ENVIRONMENT' ] = env

  sh %{middleman build --verbose}
    
end