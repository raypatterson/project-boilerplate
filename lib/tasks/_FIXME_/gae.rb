#!/usr/bin/env ruby

require 'fileutils'

ROOT = File.expand_path "."
SOURCE = File.join ROOT, 'source'
CONFIG = File.join ROOT, 'config/ga'
BUILD = File.join ROOT, 'build/public'

VERSION = "master"
APPID = "project-boilerplate"
GAE_UN = "your.account@gmail.com"

LOCALHOST = "http://localhost:"
port = 9999

namespace :gae do

  desc "Google App Engine : Start Local Server"
  task :s, [:port] do |t, args|
    port = args.port || port
    sh %{dev_appserver.py --port=#{port} #{BUILD}}
  end

  namespace :deploy do
    
    desc "Google App Engine : Deploy : ALL >>> USE WITH CAUTION!!!"
    task :all, [:branch] do |t, args|
      Rake::Task["gae:deploy:dev"].invoke args.branch
      Rake::Task["gae:deploy:review"].invoke args.branch
      Rake::Task["gae:deploy:staging"].invoke args.branch
      Rake::Task["gae:deploy:production"].invoke args.branch
    end

    desc "Google App Engine : Deploy : DEVELOPMENT"
    task :dev, [:version] => [] do |t, args|
      deploy @ENV_DEVELOPMENT, args.version
    end

    desc "Google App Engine : Deploy : REVIEW"
    task :review, [:version] => [] do |t, args|
      deploy @ENV_REVIEW, args.version
    end

    desc "Google App Engine : Deploy : QA"
    task :staging, [:version] => [] do |t, args|
      deploy @ENV_STAGING, args.version
    end

    desc "Google App Engine : Deploy : PRODUCTION"
    task :production, [:version] => [] do |t, args|
      deploy @ENV_PRODUCTION, args.version
    end

  end

  namespace :utils do

    desc "Google App Engine : Utils : Rollback"
    task :rollback, [:env] => [] do |t, args|
      cmd 'rollback', args.env, VERSION
    end

    desc "Google App Engine : Utils : Update Cron"
    task :update_cron, [:env] => [] do |t, args|
      cmd 'update_cron', args.env, VERSION
    end
    
  end

end

def deploy(env, version)

  env ||= @ENV_DEVELOPMENT
  version ||= VERSION

  Rake::Task[:build].invoke
  Rake::Task[:move_config].invoke env

  cmd 'update', env, version
end

def command(cmd, env, version)

  env ||= @ENV_DEVELOPMENT
  version ||= VERSION

  sh %{appcfg.py --application=#{env}-#{APPID} --version=#{version} --email=#{GAE_UN} --no_cookies --noisy #{cmd} #{BUILD}}
end

def move_config(env)
  FileUtils.cp "#{CONFIG}/#{(env || @ENV_DEVELOPMENT)}.app.yaml", "#{BUILD}/app.yaml"
end