def self.resource_type
  :timesyncd
end

include SystemdCookbook::ResourceFactory::Misc

default_action :create
