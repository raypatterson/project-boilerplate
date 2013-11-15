#!/usr/bin/env ruby

module Load

  def Load.yaml( path )

    file = File.open "#{path}.yaml"

    data = YAML.load file 

    # puts data

    data

  end

end