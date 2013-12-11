class DeployGitHub < Middleman::Extension

  def initialize(app, options_hash={}, &block)

    super

    app.after_configuration do | config |

      app.after_build do | builder |

        puts ">>> Deploy to GitHub Pages"

        ::Middleman::Cli::Deploy.new.deploy

      end

    end

  end

end