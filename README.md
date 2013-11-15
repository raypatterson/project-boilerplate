## Objectives

For small-to-mid sized projects - centralize and define:

- development solutions
- best practices
- workflows
- toolsets

---

## Tools

- [Bundler](http://bundler.io/)
- [Middleman](http://middlemanapp.com/)
- [rbenv](https://github.com/sstephenson/rbenv)

---

## Quick Start

### Running Locally

From the command line:

```
$ git clone git@github.com:RayPatterson/project-boilerplate.git; cd project-boilerplate
$ gem install bundler; bundle install; rake mm:s
```

After the gem bundling is complete, <br>
Middleman will begin running a server and display something like:

```
middleman server -p 8888
== The Middleman is loading
== LiveReload is waiting for a browser to connect
== The Middleman is standing watch at http://0.0.0.0:8888
== Inspect your site configuration at http://0.0.0.0:8888/__middleman/
```
Open you broswer to [http://localhost:8888](http://localhost:8888) or run:

```
$ rake browser:chrome
```
The browser should display "You are using project-boilerplate."

> **INFO**
<br>
To run the server on a different port:
```
$ rake mm:s[1234]
```

### Building Files

This will require installing a few things if you want the [Favicon Maker](https://github.com/follmann/middleman-favicon-maker) and [Image Optim](https://github.com/plasticine/middleman-imageoptim) extensions to work.

If you don't have [Homebrew](http://brew.sh/), God help you. If you do:

```
$ brew install imagemagick advancecomp gifsicle jhead jpegoptim jpeg optipng pngcrush
```

[Pngout](http://www.jonof.id.au/kenutils) is still in the stone age at the time of writing, so:

1. [Click here](http://static.jonof.id.au/dl/kenutils/pngout-20130221-darwin.tar.gz) to download the universal Mac binaries.
1. Unzip and copy the `pngout` binary to `/usr/bin`

Now run:

```
$ rake mm:build:development
```

A `build` directory should appear in the project root.

---

## Project Structure

### Top Level Folders

`source` Contains all source files that are processed and compiled by Middleman into the `build` directory.

`data` Contains [YAML](http://yaml.org/) files used to define parameters for Rake [tasks](#rake_tasks) and Middleman template [data](http://middlemanapp.com/advanced/local-data/).

`lib` Contains all Rake [tasks](#rake_tasks). Some can be used for any project, however some have very specific uses and require configuration.

### Top Level Files

> **INFO**
<br>
Not sure what these [dotfiles](http://dotfiles.github.io/) and configs do?
<br>
Don't worry, it's safe to leave them in your project.

######Important

- [.gitignore](https://help.github.com/articles/ignoring-files#global-gitignore) - If you find some of your files or folders are not being committed, check this file to see if they are being ignored. Chances are you don't need to version them.
- [.ruby-version](https://github.com/sstephenson/rbenv#choosing-the-ruby-version) - Specifies Ruby version for [rbenv](https://github.com/sstephenson/rbenv) (recommended) or [RVM](https://rvm.io/) (legacy).
- [Gemfile](http://bundler.io/v1.3/gemfile.html) - Used by [Bundler](http://bundler.io/) to define Ruby gem dependencies. `Gemfile.lock` is generated from this file and should not be edited directly.
- [config.rb](http://middlemanapp.com/getting-started/#toc_3) - The [Middleman](http://middlemanapp.com/) configuration file. Activates and configures Middlman [extensions](#middleman_extensions).

######Miscellaneous

- [Rakefile](http://rake.rubyforge.org/doc/rakefile_rdoc.html) - Requires all Rake [tasks](#rake_tasks) inside `lib/tasks` folder.
- [.editorconfig](http://editorconfig.org/) - Editor config.
- [.jsbeautifyrc](https://github.com/einars/js-beautify#options) - For use with [jsFormat](https://github.com/jdc0589/JsFormat) Sublime Text plugin.
- [.rbenv-gemsets](https://github.com/jf/rbenv-gemset#usage) - Specifies [Gemset](http://rvm.io/gemsets/basics) name for [rbenv](https://github.com/sstephenson/rbenv) Gemset [plugin](https://github.com/jf/rbenv-gemset).

######Deprecated

- [config.ru](http://middlemanapp.com/getting-started/#toc_5) - Heroku related [Rack](https://devcenter.heroku.com/articles/rack) middleware configuration that provides basic auth, device detection and redirect functionality.
- [.env](http://ddollar.github.io/foreman/#ENVIRONMENT) & [Procfile](http://ddollar.github.io/foreman/#PROCFILE)- [Heroku](https://devcenter.heroku.com/articles/procfile) related [Foreman](http://ddollar.github.io/foreman/) configurations.

---
	
## Boilerplate

#### Middleman

This is a configured Middleman project. The project utilizes MM to "build" or "compile" the code base for deployment. Commands have been wrapped in Rake tasks to target development and production build types.

#### Startup

This system defines a solution for a sequence of async events in which initializes different areas of concern within the project structure. It's currently using [Nimble](http://caolan.github.io/nimble/) but should be converted to jQuery [Promises](http://api.jquery.com/promise/).

#### Configuration

The `data/config.yaml` file contains some externalized data that is used by Middleman in `config.rb`, some of the deployment tasks in `lib/tasks` and can also be read directly into Middleman templates though the [data](http://middlemanapp.com/advanced/local-data/) object.

The Middleman `config.rb` can also be used to pass the values from `data/config.yaml` into the application templates. An example of this can be seen in `source/assets/js/project/config-js` where the helper `<%= build_version %>` is used to assigned the build version ID to a JavaScript variable.

> **INFO**
<br>
In [Sprockets](https://github.com/sstephenson/sprockets), files can be converted to multiple types by multiple processing engines during compiling routine. The order is dictated by the chainign of file extensions. The process for the default Middleman [templating](http://middlemanapp.com/templates/) is explained [here](https://github.com/sstephenson/sprockets#invoking-ruby-with-erb) but in short, if you add the `.erb` extension to any file, you can write Ruby in it access the data object as well as Middleman [Template Helpers](http://middlemanapp.com/helpers/).

---
	
## Optional

#### Mobile Detection & Redirect (MDR)

The relationships between desktop/tablet/mobile apps for each environment are set within the `data/config.yaml` file. 

<span style="color:red">In both the middleware and client-side soltions, Android tablets are treated the same as Android mobile devices.</span>

###### _Rack Middleware Solution_

If you are deploying to a hosting service such as Heroku that supports Rack middleware, you may use a middleware based solution. 

The current solution in place is <https://github.com/talison/rack-mobile-detect>

There is some additional configuration that can take place within the Rack config `config.ru` file.

###### _Client-Side JavaScript Solution_

If the redirect needs to rely on JavaScript you may follow these steps:

1. Open `source/assets/js/lib/redirect/redirect.js`
2. Replace "REDIRECT-URL-{DEVICE}" with the appropriate redirect URL's.
3. Replace "REDIRECT-SEARCH-PATTERN" with the appropriate search patterns.
4. Optionally replace "REDIRECT-URL-IGNORE" if you want to bypass the redirect on specific URL's.
5. If you are running on a local port other than "8888" replace as necessary.
6. Embed this file into the <head> tag of `source\index.html.erb`.

> **INFO**
<br>
Once the redirects have been verified, it's recommended for optimial performance that you minify this script and replace the embed of the external file and copy the minified code block into the script tags.

---

## Deployment

#### Unversioned Development Builds

The build can be compiled without incrementing the build version Id with the following command:

```
$ rake mm:build:development
```

#### Versioned Staging Builds

The build can be versioned manually with the following command:

```
$ rake version:increment
```

The build will be versioned automatically when compiling a Staging build for release using the following command:

```
$ rake mm:build:staging
```

Each build has a version number that is always visible on the client as long as the `console` object exists. 

E.g. `Build Version --> v0099`

When in testing and production phases, build version Ids can correspond with the names of the released build versions in the issue tracking system.

These associations can be made by the Release Manager.

#### Tagged Production Builds

Once the `develop` branch has been merged successfully into the `master` branch, the build can be tagged in with the following command:

```
$ rake version:tag
```

In order for the production release tags to make it to the origin (GitHub) repository, you must use the following command:

```
$ git push origin master --tags
```

#### Amazon Web Services (S3 + CloudFront)

Documentation pending.


---
