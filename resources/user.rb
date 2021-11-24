def self.resource_type
  :user
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
