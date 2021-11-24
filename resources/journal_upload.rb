def self.resource_type
  :'journal-upload'
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
