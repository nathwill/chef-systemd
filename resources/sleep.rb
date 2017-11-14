def self.resource_type
  :sleep
end

include SystemdCookbook::ResourceFactory::Misc

default_action :create
