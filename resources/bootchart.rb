def self.resource_type
  :bootchart
end

include SystemdCookbook::ResourceFactory::Misc

default_action :create
