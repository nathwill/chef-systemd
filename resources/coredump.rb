def self.resource_type
  :coredump
end

include SystemdCookbook::ResourceFactory::Misc

default_action :create
