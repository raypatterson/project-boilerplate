require 'yaml'
require 'middleman'
require 'middleman/builder'
require 'rack'
require 'rack/request'
require 'rack/mobile-detect'
require 'rack/contrib/try_static'

# Get Rack environment key value.
environment = ENV["RACK_ENV"].to_s

# Load YAML config file.
yml = YAML::load(File.open("data/config.yaml"))

# Try to set config object --> or default to production.
config = yml['environments'][environment] || yml['environments']['production']

# Check for mobile devices and perform redirect.
# TODO : [RKP] : Update Redirect Solution
# This redirect solution does not differentiate 
# between Android phone and tablet devices.
# There is a more intelligent solution called
# Mobvious [https://github.com/jistr/mobvious]
# It requires a more robust Rack setup and I have
# yet to get it to work reliably.
protocol = "#{yml['site']['protocol']}://"
desktop_url = "#{protocol}#{(config['urls']['desktop'])}"
mobile_url = "#{protocol}#{(config['urls']['mobile'])}"

if mobile_url != nil and mobile_url != desktop_url
  use Rack::MobileDetect, :catchall => /iPad|iPod|iPhone|Android|Blackberry|Samsung|webOS/i,
                          :redirect_map => { 
                            'iPod' => mobile_url,
                            'iPhone' => mobile_url,
                            'Android' => mobile_url,
                            'BlackBerry' => mobile_url,
                            'Samsung' => mobile_url,
                            'webOS' => mobile_url
                            }
                            
end

# Perform Middleman build to "tmp" dir.
ENV['ENVIRONMENT'] = environment
Middleman::Builder.start

auth = config['auth']
if auth != nil
  use Rack::Auth::Basic, "Please sign in to view site." do |username, password|
    [username, password] == [auth['username'], auth['password']]
  end
end

# Serve static files from "tmp" dir.
use Rack::TryStatic,
  :root => 'build',
  :urls => %w[/],
  :try => ['.html', 'index.html', '/index.html']

# Pretty sure this doesn't actually work.
run lambda { |env|
  [
    404,
    {
      'Content-Type' => 'text/html'
    },
    File.open('build/404.html', File::RDONLY)
  ]
}
