def self.resource_type
  :system
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
