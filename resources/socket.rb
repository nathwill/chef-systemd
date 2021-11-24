def self.resource_type
  :socket
end

include SystemdCookbook::ResourceFactory::Unit

unified_mode true

default_action :create
