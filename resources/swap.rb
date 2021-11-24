def self.resource_type
  :swap
end

include SystemdCookbook::ResourceFactory::Unit

unified_mode true

default_action :create
