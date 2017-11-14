def self.resource_type
  :target
end

include SystemdCookbook::ResourceFactory::DropIn

default_action :create
