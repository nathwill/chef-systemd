def self.resource_type
  :coredump
end

include SystemdCookbook::ResourceFactory::Daemon
