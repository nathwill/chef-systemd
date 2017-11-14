def self.resource_type
  :slice
end

include SystemdCookbook::ResourceFactory::DropIn

default_action :create
