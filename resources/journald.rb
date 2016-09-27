def self.resource_type
  :journald
end

include SystemdCookbook::ResourceFactory::Daemon
