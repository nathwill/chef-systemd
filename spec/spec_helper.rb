require 'chefspec'
require 'chefspec/berkshelf'

Dir.glob('libraries/*.rb').shuffle.each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.platform = 'centos'
  config.version = '7.8.2003'
end
