## Status

| Staging  | Production  |
|----------|-------------|
| [![Build Status](https://travis-ci.org/RayPatterson/project-boilerplate.png?branch=staging)](https://travis-ci.org/RayPatterson/project-boilerplate) | [![Build Status](https://travis-ci.org/RayPatterson/project-boilerplate.png?branch=production)](https://travis-ci.org/RayPatterson/project-boilerplate) |


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
$ ./setup.sh
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
The browser should display a small set of modules.

> **INFO**
<br>
To run the server on a different port:
```
$ rake mm:s[1234]
```

### Changing Files

In the interests of segregating the top-level Middleman framework configuration workstream from any related to application development, the `source` directory is imported from a [separate GitHub project](https://github.com/RayPatterson/project-boilerplate-source).

The default configuration is using the [development](https://github.com/RayPatterson/project-boilerplate-source/tree/development) branch. If you wish to begin your project with another branch run:

```
$ rake source:change[<branchname>]
```

Each `<branchname>` listed expands on the previous one. Current options are:

1. minimal - [Modernizr](http://modernizr.com/) and [Normalize.css](http://necolas.github.io/normalize.css/), [application bootstrapping](http://api.jquery.com/deferred.promise/)
1. single-page - [Component architecture](https://github.com/yeoman/generator-angular/issues/109), [Bourbon](http://bourbon.io/) and [Neat](http://neat.bourbon.io/), [clowncar image](http://coding.smashingmagazine.com/2013/06/02/clown-car-technique-solving-for-adaptive-images-in-responsive-web-design/), [placeholders](http://middlemanapp.com/basics/helpers/#toc_7)
1. multi-page - [Backbone Marionette](http://marionettejs.com/), [Mediaelement.js](http://mediaelementjs.com/) + [YouTube](http://mediaelementjs.com/examples/?name=youtube), [some](http://www.woothemes.com/flexslider/) [carousels](http://bxslider.com/) 

### Installing rbenv

If you don't have [rbenv](https://github.com/sstephenson/rbenv), now's the time to get it.

```
$ brew update; brew install rbenv ruby-build rbenv-gemset
```

Homebrew will prompt you to add the following to your `.bash_profile`.

```
export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
```

In order for rbenv commands to be found you will also need to add the line:

`export PATH="$PATH:/usr/local/opt/rbenv/shims:/usr/local/opt/rbenv"`

```
$ mkdir /usr/local/var/rbenv/plugins; git clone https://github.com/sstephenson/rbenv-gem-rehash.git /usr/local/var/rbenv/plugins/rbenv-gem-rehash
$ rbenv install 1.9.3-p247
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

---
	
## Boilerplate

#### Middleman

This is a configured Middleman project. The project utilizes MM to "build" or "compile" the code base for deployment. Commands have been wrapped in Rake tasks to target development and production build types.

#### Configuration

The `data` folder contains some externalized data that is used by Middleman in `config.rb`, some of the deployment tasks in `lib/tasks` and can also be read directly into Middleman templates though the [data](http://middlemanapp.com/advanced/local-data/) object.

The Middleman `config.rb` can also be used to pass the values from `data/config.yaml` into the application templates. An example of this can be seen in `source/assets/js/app.js` where the helper `<%= build_version %>` is used to assigned the build version ID to a JavaScript variable.

> **INFO**
<br>
In [Sprockets](https://github.com/sstephenson/sprockets), files can be converted to multiple types by multiple processing engines during compiling routine. The order is dictated by the chainign of file extensions. The process for the default Middleman [templating](http://middlemanapp.com/templates/) is explained [here](https://github.com/sstephenson/sprockets#invoking-ruby-with-erb) but in short, if you add the `.erb` extension to any file, you can write Ruby in it access the data object as well as Middleman [Template Helpers](http://middlemanapp.com/helpers/).

---

## Builds

There are currently 4 types of builds to support a variety of workstreams and approval processes:

| Environment | Audience        | Task                          |
|-------------|-----------------|-------------------------------|
| Production  | User            | `$ rake mm:build:production`  |
| Staging     | Tester          | `$ rake mm:build:staging`     |
| Review      | Stakeholder     | `$ rake mm:build:review`      |
| Development | Developer       | `$ rake mm:build:development` |


## Deployments

Activating deployments and their repective targets is configured in: `data/project/deployment.yml`

Available build targets are:

1. [GitHub Pages](http://pages.github.com/)
1. [Amazon Web Services](http://aws.amazon.com/)

The option to deploy review builds to [Heroku](https://www.heroku.com/) with [basic auth](http://en.wikipedia.org/wiki/Basic_access_authentication) is forthcoming.

#### GitHub Pages

By default, the `development` build is configured to automatically deploy to [GitHub Pages](http://raypatterson.github.io/project-boilerplate/).

#### AWS S3 + CloudFront

> **INFO**
<br>
Setting up [S3](http://aws.amazon.com/s3/) origin buckets and corresponding [CloudFront](http://aws.amazon.com/cloudfront/) CDN distributions is currently beyond the scope of this documentation. 

AWS is configured in: `data/project/aws.yml`

```
staging:
  region: "us-west-1"                     # S3 bucket region
  bucket: "project-boilerplate-staging"   # S3 bucket name
  subdomain: "d3j8fwmkh3oq8e"             # CloudFront subdomain
  distribution_id: "E36OCSKSYBD2LH"       # CloudFront distribution id
```

Deployment is configured in: `data/project/deployment.yml`

```
staging:
  active: false    # Activates deployment process
  target: "aws"    # Defines deploy target
```

#### Travis CI

> **INFO**
<br>
Setting up [Travis CI](https://travis-ci.org/RayPatterson/project-boilerplate/) is currently beyond the scope of this documentation. 

Pushing to either the `staging` or `production` branches will trigger Travis to perform a build and deploy.

Encypting your AWS keys:

```
$ travis encrypt S3_ACCESS_KEY_ID=AKQA… --add env.global
$ travis encrypt S3_SECRET_KEY_ID=SHHH… --add env.global
```

Replace the the secure keys in: `.travis.yml`

```
env:
  global:
  - secure: m7ET...
  - secure: Nr2R…
```

> **INFO**
<br>
When the site debugging flag is `true` the Travis build number will be visible within the console.
<br>
E.g. `Build Version --> 99`


#### Versioning Builds

Versioning is configured in: `data/project/deployment.yml`

```
staging:
  increment: true   # Increments the build version
```

The build version ID will be visible in the console.

E.g. `Build Version --> v0099`


The build can be manually versioned with:

```
$ rake version:increment
```

#### Tagging Builds

Tagging is configured in: `data/project/deployment.yml`

```
production:
  tag: true                     # Activates tagging process
  message: "Today is the day"   # Optional Message
```

The build can be manually tagged with:

```
$ rake version:tag
```

Then push with the following:

```
$ git push --tags
```

---
	
## Optional

#### Mobile Detection & Redirect (MDR)

The relationships between desktop/tablet/mobile apps for each environment are set within the `data/config.yaml` file. 

> **INFO**
<br>
<span style="color:red">In both the middleware and client-side soltions, Android tablets are treated the same as Android mobile devices.</span>

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

###### <span style="color:red">Depricated</span> _Rack Middleware Solution_ 

If you are deploying to a hosting service such as Heroku that supports Rack middleware, you may use a middleware based solution. 

The current solution in place is <https://github.com/talison/rack-mobile-detect>

There is some additional configuration that can take place within the Rack config `config.ru` file.

---
