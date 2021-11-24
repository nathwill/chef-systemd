def self.resource_type
  :service
end

include SystemdCookbook::ResourceFactory::DropIn

unified_mode true

default_action :create
