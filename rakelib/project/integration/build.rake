#!/usr/bin/env ruby

require './lib/modules/config'
require './lib/modules/site'
require './lib/modules/aws'

namespace :project do
  
  # Build Tasks
  namespace :build do
    
    desc "Project : Build : DEVELOPMENT"
    task :development do
      project_build Cfg.get_development_env
    end
    
    desc "Project : Build : REVIEW"
    task :review do
      project_build Cfg.get_review_env
    end
    
    desc "Project : Build : STAGING"
    task :staging do
      project_build Cfg.get_staging_env
    end
    
    desc "Project : Build : PRODUCTION"
    task :production do
      project_build Cfg.get_production_env
    end
    
  end
  
end

def project_build( env )

  puts ">>> Building to #{env}"

  Rake::Task["mm:build:#{env}"].invoke

  puts ">>> Deploying to #{env}"

  Dir.chdir ".."

  root = ( File.expand_path "." )

  static_root = "#{root}/src-frontend/build/"
  app_root = "#{root}/"
  webapp_root = "#{app_root}src/main/webapp/"

  Rake::Task["project:utils:copy_files"].invoke static_root, webapp_root, [ "index.html" ]
  Rake::Task["project:utils:change_file_extensions"].invoke webapp_root, "html", "jsp"

  asset_path_prefix = AWS.cloudfront_url env

  file_list = [ "#{webapp_root}index.jsp" ]

  Rake::Task["project:utils:prefix_asset_paths"].invoke asset_path_prefix, file_list

  app_target_dir = "#{app_root}target/"

  app_target = "#{app_target_dir}#{Site.get_id}-3.0.0.war" # The name of the app package that Maven creates

  app_version = "#{Site.get_id}-#{env}"

  if env == Cfg.get_staging_env || env == Cfg.get_production_env
    app_version = "#{app_version}-#{Cfg.get_build_version}"
  end

  app_package = "#{app_target_dir}#{app_version}.war"

  Rake::Task["project:utils:package_webapp"].invoke app_root, app_target, app_package

  Rake::Task["project:utils:deploy_to_eb"].invoke app_version, app_package, env

end