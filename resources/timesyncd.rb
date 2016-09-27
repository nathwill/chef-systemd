def self.resource_type
  :timesyncd
end

include SystemdCookbook::ResourceFactory::Daemon
