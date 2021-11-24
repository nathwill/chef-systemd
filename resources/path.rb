def self.resource_type
  :path
end

include SystemdCookbook::ResourceFactory::Unit

unified_mode true

default_action :create
