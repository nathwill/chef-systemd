def self.resource_type
  :socket
end

include SystemdCookbook::ResourceFactory::DropIn

unified_mode true

default_action :create
