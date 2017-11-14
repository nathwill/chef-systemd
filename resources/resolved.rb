def self.resource_type
  :resolved
end

include SystemdCookbook::ResourceFactory::Misc

default_action :create
