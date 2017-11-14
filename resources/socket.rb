def self.resource_type
  :socket
end

include SystemdCookbook::ResourceFactory::Unit

default_action :create
