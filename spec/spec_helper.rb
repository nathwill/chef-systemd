require 'chefspec'
require 'chefspec/berkshelf'

Dir.glob('libraries/*.rb').shuffle.each { |f| require File.expand_path(f) }

ChefSpec::Coverage.start!
