def self.resource_type
  :mount
end

include SystemdCookbook::ResourceFactory::Unit

default_action :create
