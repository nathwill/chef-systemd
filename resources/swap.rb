def self.resource_type
  :swap
end

include SystemdCookbook::ResourceFactory::Unit

default_action :create
