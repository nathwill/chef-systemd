def self.resource_type
  :user
end

include SystemdCookbook::ResourceFactory::Misc

default_action :create
