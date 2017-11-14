def self.resource_type
  :slice
end

include SystemdCookbook::ResourceFactory::Unit

default_action :create
