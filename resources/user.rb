def self.resource_type
  :user
end

include SystemdCookbook::ResourceFactory::Daemon
