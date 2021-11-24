def self.resource_type
  :timesyncd
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
