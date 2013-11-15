#!/usr/bin/env ruby

require 'fileutils'
require './lib/modules/aws'

namespace :project do

  # Project Utils
  namespace :utils do

    desc "Package_WebApp"
    task :package_webapp, [ :app_root, :app_target, :package_filename, :env ] do | t, args |

    Dir.chdir "#{args.app_root}"

    root = ( File.expand_path "." )
    target_dir = "#{root}/target/"
    app_archive = "#{args.app_target}.war"

    # Create WAR file

    sh %{mvn clean install}

    FileUtils.mv "#{target_dir}#{app_archive}", "#{target_dir}#{args.package_filename}.war"
    
    # Create deploy dir

    # deploy_dir = "#{target_dir}deploy/"

    # FileUtils.remove_dir "#{deploy_dir}", :verbose => true
    # FileUtils.mkdir "#{deploy_dir}", :verbose => true
    
    # # Move WAR file to deploy dir

    # FileUtils.mv "#{target_dir}#{app_archive}", "#{deploy_dir}", :verbose => true

    # # Move AWS config to deploy dir

    # FileUtils.cp_r "#{root}/.elasticbeanstalk", "#{deploy_dir}", :verbose => true
    
    # # Create GIT repo in deploy dir

    # Dir.chdir "#{deploy_dir}"

    # sh %{unzip -o "#{app_archive}"}

    # FileUtils.rm "#{app_archive}"

    # sh %{git init}
    # sh %{git add -A}
    # sh %{git commit -m "Deployed new version"}
    # sh %{git status}

    # access_key = AWS.access_key
    # secret_key = AWS.secret_key

    # sh %{eb push -I "#{access_key}" -S "#{secret_key}" --verbose}

    end

  end

end
