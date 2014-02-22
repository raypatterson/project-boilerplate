source "https://rubygems.org"

Dir.glob(File.join(File.dirname(__FILE__), "gemfiles", "**", "*")) do | gemfile |
  if File.file?(gemfile)
    eval(IO.read(gemfile), binding)
  end
end
