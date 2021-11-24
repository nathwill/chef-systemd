def self.resource_type
  :automount
end

include SystemdCookbook::ResourceFactory::Unit

unified_mode true

default_action :create
