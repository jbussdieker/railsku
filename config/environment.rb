require 'railsku'

puts "Starting Railsku..."

apps = []

Railsku::Router.setup_backends(apps)
