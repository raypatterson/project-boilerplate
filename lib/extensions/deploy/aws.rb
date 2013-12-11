class DeployAws < Middleman::Extension

  def initialize( app, options_hash = {}, &block )

    super

    app.after_configuration do | config |

      app.after_build do | builder |

        puts ">>> Deploy AWS : Sync S3 Origin"

        ::Middleman::S3Sync.sync

        puts ">>> Deploy AWS : Invalidate CloudFront CDN"

        ::Middleman::Cli::CloudFront.new.invalidate

      end

    end

  end

end