def self.resource_type
  :target
end

include SystemdCookbook::ResourceFactory::Unit

default_action :create
