def self.resource_type
  :'journal-upload'
end

include SystemdCookbook::ResourceFactory::Misc

default_action :create
