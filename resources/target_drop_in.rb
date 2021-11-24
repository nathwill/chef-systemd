def self.resource_type
  :target
end

include SystemdCookbook::ResourceFactory::DropIn

unified_mode true

default_action :create
