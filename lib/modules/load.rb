#!/usr/bin/env ruby

require "erb"

module Load

  def Load.yaml( path )

    data = YAML.load(ERB.new(File.read("#{path}.yml")).result)

    # puts data

    data

  end

end