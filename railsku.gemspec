Gem::Specification.new do |gem|
  gem.name    = "railsku"
  gem.version = "0.0.1"
  gem.summary = ""
  gem.authors = ["jbussdieker@gmail.com"]
  gem.files = Dir["lib/**/*"]
  gem.executables = "railsku"

  gem.add_runtime_dependency 'rack'
  gem.add_runtime_dependency 'unicorn'
end
