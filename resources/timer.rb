def self.resource_type
  :timer
end

include SystemdCookbook::ResourceFactory::Unit

unified_mode true

default_action :create
