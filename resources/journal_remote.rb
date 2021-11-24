def self.resource_type
  :'journal-remote'
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
