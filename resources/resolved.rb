def self.resource_type
  :resolved
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
