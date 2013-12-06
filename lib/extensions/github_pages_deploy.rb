class GitHubPagesDeploy < Middleman::Extension

  def initialize(app, options_hash={}, &block)

    super

    app.after_build do | builder |

      puts "Deploy to GitHub Pages"

      `middleman deploy`

    end

  end

end