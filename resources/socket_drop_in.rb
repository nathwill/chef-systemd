def self.resource_type
  :socket
end

include SystemdCookbook::ResourceFactory::DropIn

default_action :create
