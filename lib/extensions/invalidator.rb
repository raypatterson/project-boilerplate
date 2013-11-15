class Invalidator < Middleman::Extension
  # All the options for this extension
  option :access_key, false, 'AWS Access Key'
  option :secret_key, false, 'AWS Secret Key'
  option :distribution_id, false, 'AWS Distribution ID'

  def initialize( app, options_hash = {}, &block )
    
    super

    $options = options

    app.after_build do | builder |

      puts $options.access_key
      puts $options.secret_key
      puts $options.distribution_id

      invalidator = CloudfrontInvalidator.new( $options.access_key, $options.secret_key, $options.distribution_id )

      list = %w[
        index.html
      ]

      invalidator.invalidate( list ) do | status, time |

        invalidator.list
        invalidator.list_detail

        puts "Complete after < #{time.to_f.ceil} seconds." if status == "Complete"

      end

    end
  end
end