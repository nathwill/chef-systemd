def self.resource_type
  :service
end

include SystemdCookbook::ResourceFactory::Unit

default_action :create
