version = File.read(File.expand_path("../VERSION", __FILE__)).strip

Gem::Specification.new 'sandbox-sinatra', version do |s|
  s.description       = "testing, testing, testing"
  s.summary           = "sinatra sandbox"
  s.authors           = ["namusyaka"]
  s.email             = "namusyaka@gmail.com"
  s.homepage          = "http://namusyaka.com/"
  s.license           = 'MIT'
  s.files             = Dir['README*.md', 'lib/**/*'] + [
    "CHANGELOG.md",
    "Gemfile",
    "LICENSE",
    "Rakefile",
    "sandbox-sinatra.gemspec",
    "VERSION"]
  s.extra_rdoc_files  = s.files.select { |p| p =~ /^README/ } << 'LICENSE'
  s.rdoc_options      = %w[--line-numbers --inline-source --title sandbox-sinatra --main README.rdoc --encoding=UTF-8]
end
