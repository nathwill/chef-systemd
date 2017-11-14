def self.resource_type
  :path
end

include SystemdCookbook::ResourceFactory::DropIn

default_action :create
