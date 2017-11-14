def self.resource_type
  :path
end

include SystemdCookbook::ResourceFactory::Unit

default_action :create
