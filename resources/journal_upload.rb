def self.resource_type
  :'journal-upload'
end

include SystemdCookbook::ResourceFactory::Daemon
