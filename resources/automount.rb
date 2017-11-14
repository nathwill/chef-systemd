def self.resource_type
  :automount
end

include SystemdCookbook::ResourceFactory::Unit

default_action :create
