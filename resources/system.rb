def self.resource_type
  :system
end

include SystemdCookbook::ResourceFactory::Misc

default_action :create
