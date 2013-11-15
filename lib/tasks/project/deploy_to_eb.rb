#!/usr/bin/env ruby

require "digest"
require "eb_deployer"
require './lib/modules/aws'

namespace :project do

  # Project Utils
  namespace :utils do

    desc "Deploy to Elastic Beanstalk"
    task :deploy_to_eb, [ :app_version, :app_package, :env ] do | t, args |

      AWS.config(
        access_key_id: AWS.access_key, 
        secret_access_key: AWS.secret_key, 
        region: AWS.eb_region
        )

      EbDeployer.deploy(
        :application => AWS.eb_name,
        :environment => ( AWS.eb_env args[:env] ),
        :solution_stack_name =>  AWS.eb_stack,
        :package => args[:app_package],
        :version_label => Digest::MD5.file(args[:app_package]).hexdigest) + "-" + args[:app_version]

    end

  end

end
