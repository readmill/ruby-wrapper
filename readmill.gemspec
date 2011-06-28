lib = File.expand_path('../lib/', __FILE__)

$:.unshift lib unless $:.include?(lib)

require 'readmill/version'

Gem::Specification.new do |s|
  s.name        = "readmill"
  s.version     = Readmill::VERSION
  s.platform    = Gem::Platform::RUBY
  
  s.authors     = ["Jens Nockert"]
  s.email       = ["jens@readmill.com"]
  
  s.homepage    = "http://github.com/Readmill/ruby-wrapper"
  s.summary     = "The simplest way to access your Readmill readings."
  s.description = "This is a wrapper for the Readmill REST-API, there you can access books, userdata and readings from Readmill."
  
  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.md)
  
  s.add_dependency('rest-client')
  
  s.require_path = 'lib'
end
