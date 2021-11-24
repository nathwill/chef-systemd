def self.resource_type
  :target
end

include SystemdCookbook::ResourceFactory::Unit

unified_mode true

default_action :create
