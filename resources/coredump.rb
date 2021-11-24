def self.resource_type
  :coredump
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
