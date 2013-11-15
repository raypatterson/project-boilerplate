#!/usr/bin/env ruby

require 'heroku'

@apps = @yml["apps"]
@collaborators = @yml["collaborators"]
@defaults = @yml["defaults"]
@environments = @yml["environments"]

env_list = [ @ENV_DEVELOPMENT, @ENV_REVIEW ]

namespace :heroku do

  desc "Heroku : Start Local Server"
  task :s do
    ENV['HEROKU'] = @ENV_DEVELOPMENT
    sh %{foreman start}
  end

  # Utility Tasks
  namespace :utils do

    desc "Heroku : Utils : Create Apps"
    task :create_apps do
      env_list.map { |env| 
        create_app( env ) 
        config_app( env )
      }
      sh %{git remote -v}
    end

    desc "Heroku : Utils : Config Apps"
    task :config_apps do
      env_list.map { |env| config_app( env ) }
      sh %{git remote -v}
    end

    desc "Heroku : Utils : Destroy Apps"
    task :destroy_apps do
      env_list.map { |env| destroy_app( env ) }
      sh %{git remote -v}
    end

    desc "Heroku : Utils : Add Remotes"
    task :add_remotes do
      env_list.map { |env| add_remote( env ) }
      sh %{git remote -v}
    end

    desc "Heroku : Utils : Reset App"
    task :reset_app, [:env] do |t, args|
      env = args.env || @ENV_DEVELOPMENT
      destroy_app env
      create_app env
      sh %{git remote -v}
      add_collaborators env
      deploy env, nil, false
    end

    desc "Heroku : Utils : Tail Log"
    task :tail_log, [:env] do |t, args|
      env = args.env || @ENV_DEVELOPMENT
      app_name = get_app_name env
      account = @defaults["heroku"]
      sh %{heroku logs -t --app #{app_name} --account #{account}}
    end

  end

  # Deployment Tasks
  namespace :deploy do
    desc "Heroku : Deploy : ALL >>> USE WITH CAUTION!!!"
    task :all, [:branch] do |t, args|
      env_list.map { |env| Rake::Task["heroku:deploy:#{env}"].invoke args.branch }
    end

    desc "Heroku : Deploy : DEVELOPMENT"
    task :development, [:branch] do |t, args|
      deploy @ENV_DEVELOPMENT, args.branch, false, false
    end

    desc "Heroku : Deploy : REVIEW"
    task :review, [:branch] do |t, args|
      deploy @ENV_REVIEW, args.branch, false, false
    end

    desc "Heroku : Deploy : STAGING"
    task :staging, [:branch, :version, :tag] do |t, args|
      deploy @ENV_STAGING, args.branch, ( args.version || true ), ( args.tag || false )
    end

    desc "Heroku : Deploy : PRODUCTION"
    task :production, [:branch, :version, :tag] do |t, args|
      deploy @ENV_PRODUCTION, args.branch, ( args.version || true ), ( args.tag || true )
    end
  end
end

def add_collaborators (env)
  app_name = get_app_name env
  @collaborators.each do |collaborator|
    sh %{heroku sharing:add #{collaborator} --app #{app_name}}
  end
  sh %{heroku sharing --app #{app_name}}
end

def create_app (env)
  app_name = get_app_name env
  account = @defaults["heroku"]
  sh %{heroku apps:create -r #{env} -s cedar #{app_name} --account #{account}}
end

def config_app (env)
  app_name = get_app_name env
  account = @defaults["heroku"]
  sh %{heroku config:unset RACK_ENV --app #{app_name} --account #{account}}
  sh %{heroku config:set RACK_ENV=#{env} --app #{app_name} --account #{account}}
  sh %{heroku config --app #{app_name} --account #{account}}
end

def destroy_app (env)
  app_name = get_app_name env
  account = @defaults["heroku"]
  sh %{heroku apps:destroy --confirm #{app_name} --account #{account}}
end

def add_remote (env)
  app_name = get_app_name env
  remote_url = "git@heroku.com:#{app_name}.git"
  # sh %{git remote rm #{env}}
  sh %{git remote add #{env} #{remote_url}}
end

def get_app_name (env)
  return @apps[env]
end

def get_environment_branch_name (env)
  return @environments[env]["branch"]
end

def deploy (env, branch, version, tag)
  branch ||= get_environment_branch_name(env) || @defaults["branch"]
  if version === true
    Rake::Task["version:increment"].invoke
  end
  if tag === true
    Rake::Task["version:tag"].invoke
  end
  # puts %{git push #{env} #{branch}:master}
  sh %{git push #{env} #{branch}:master}
end