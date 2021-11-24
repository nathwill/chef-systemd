def self.resource_type
  :mount
end

include SystemdCookbook::ResourceFactory::Unit

unified_mode true

default_action :create
