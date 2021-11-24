def self.resource_type
  :journald
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
