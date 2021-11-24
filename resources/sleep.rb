def self.resource_type
  :sleep
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
