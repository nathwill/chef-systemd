def self.resource_type
  :slice
end

include SystemdCookbook::ResourceFactory::Unit

unified_mode true

default_action :create
