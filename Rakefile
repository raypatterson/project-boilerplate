#!/usr/bin/env ruby

require 'yaml'
require 'rake/dsl_definition'

$ROOT = File.expand_path "."

def require_tasks ( folder_path )

  file_path = "#{$ROOT}/lib/tasks#{folder_path}/**/*.rb"

  Dir.glob( file_path ) { | file | require file }

end

require_tasks '/core'
require_tasks '/project'
