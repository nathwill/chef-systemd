def self.resource_type
  :bootchart
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
