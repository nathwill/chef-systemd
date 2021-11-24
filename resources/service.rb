def self.resource_type
  :service
end

include SystemdCookbook::ResourceFactory::Unit

unified_mode true

default_action :create
