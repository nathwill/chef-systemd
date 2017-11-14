def self.resource_type
  :timer
end

include SystemdCookbook::ResourceFactory::DropIn

default_action :create
