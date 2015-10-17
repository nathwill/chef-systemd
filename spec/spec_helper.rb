require 'chefspec'
require 'chefspec/berkshelf'

# Require all our libraries
Dir.glob('libraries/*.rb').shuffle.each { |f| require File.expand_path(f) }
