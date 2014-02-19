class DeployHeaders < Middleman::Extension

  def initialize( app, options_hash = {}, &block )

    super

    app.after_configuration do | config |

      app.after_build do | builder |

        puts "====================================================="
        puts ""
        puts "Adding HTTP Headers"
        puts ""

        ( Dir["#{app.build_dir}/**/*.{html,css,js}"] ).each do | file |
          file = file.gsub "build/", ""
          puts file
          ::Middleman::S3Metadata.options.s3_metadata file, 'Vary', 'Accept-Encoding'
        end

        puts ""
        puts "====================================================="
      end

    end

  end

end