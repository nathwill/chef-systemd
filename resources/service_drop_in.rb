def self.resource_type
  :service
end

include SystemdCookbook::ResourceFactory::DropIn

default_action :create
