def self.resource_type
  :timer
end

include SystemdCookbook::ResourceFactory::Unit

default_action :create
