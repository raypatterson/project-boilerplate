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
    task :development, [:deploy, :increment, :tag, :msg] do | t, args |

      env = Cfg.get_development_env
      deploy = args.deploy || false
      increment = args.increment || false
      tag = args.tag || false
      msg = args.msg || env

      build env, deploy, increment, tag, msg

    end

    desc "Middleman : Build : REVIEW"
    task :review, [:deploy, :increment, :tag, :msg] do | t, args |

      env = Cfg.get_review_env
      deploy = args.deploy || true
      increment = args.increment || false
      tag = args.tag || false
      msg = args.msg || env

      build env, deploy, increment, tag, msg

    end

    desc "Middleman : Build : STAGING"
    task :staging, [:deploy, :increment, :tag, :msg] do | t, args |

      env = Cfg.get_staging_env
      deploy = args.deploy || true
      increment = args.increment || true
      tag = args.tag || false
      msg = args.msg || env

      build env, deploy, increment, tag, msg

    end

    desc "Middleman : Build : PRODUCTION"
    task :production, [:deploy, :increment, :tag, :msg] do | t, args |

      env = Cfg.get_production_env
      deploy = args.deploy || true
      increment = args.increment || true
      tag = args.tag || true
      msg = args.msg || env

      build env, deploy, increment, tag, msg

    end

  end

end

def build( env, deploy = false, increment = false, tag = false, message = nil )

  ENV[ 'DEPLOY' ] = ( deploy == true ) ? 'true' : 'false'
  ENV[ 'ENVIRONMENT' ] = env

  if increment === true
    Version.increment_build_version
  end

  if tag === true
    Version.tag_build message
  end

  sh %{middleman build --verbose}

end