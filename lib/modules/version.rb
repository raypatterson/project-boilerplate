#!/usr/bin/env ruby

module Version

  class Methods

    include Rake::DSL

    @@FILE_NAME = File.expand_path "." + "/data/version.yaml"
    @@VERSION_VAL_PREFIX = "v"
    @@VERSION_VAL_DEFAULT = "#{@@VERSION_VAL_PREFIX}000"
    @@VERSION_KEY = "build_version"

    def initialize
      if ( File.exists? @@FILE_NAME ) === false
        create_file @@VERSION_VAL_DEFAULT
      end
    end

    def create_file( val )
      file = File.new @@FILE_NAME, 'w'
      file.write "#{@@VERSION_KEY}: #{val}"
      file.close()
    end

    def delete_file
      File.delete @@FILE_NAME
    end

    def get_version
      ( YAML::load ( File.open @@FILE_NAME, 'r+' ) ).each_pair do | key, val |
        if key === @@VERSION_KEY
          return val.to_s
        end
      end
    end

    def git_commit( message )
      sh %{git add -A}
      sh %{git commit -m "#{message}"}
    end

    def increment_build_version( release = nil )

      s = ( get_version().split @@VERSION_VAL_PREFIX )[ 1 ]

      i = s.to_i.to_s.to_i + 1

      s = i.to_s.rjust 3, "0"

      val = "#{@@VERSION_VAL_PREFIX}#{s}"
      
      puts "Updated Build Version : #{val}"

      delete_file()
      create_file val

    end

    def tag_build( message = nil )

      val = get_version()

      if message
        message = "#{val}-#{message}"
      end
      
      puts "Tagging Build Version : #{val}"

      begin
        git_commit message
        sh %{git tag -a #{val} -m "#{message}"}
      rescue Exception => e
        puts "----------------------------"
        puts "!!! Something went worng !!!"
        puts e
        puts "----------------------------"
      ensure
        sh %{git tag -l -n}
        sh %{git status}
      end
    end

  end

  @@m = Methods.new

  def self.get_version
    @@m.get_version()
  end

  def self.increment_build_version( release = nil )
    @@m.increment_build_version release
  end

  def self.tag_build( message = nil )
    @@m.tag_build message
  end
  
end