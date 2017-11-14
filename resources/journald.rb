def self.resource_type
  :journald
end

include SystemdCookbook::ResourceFactory::Misc

default_action :create
