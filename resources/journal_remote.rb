def self.resource_type
  :'journal-remote'
end

include SystemdCookbook::ResourceFactory::Daemon
