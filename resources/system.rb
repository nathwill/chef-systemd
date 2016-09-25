def self.daemon_type
  :system
end

include SystemdCookbook::ResourceFactory::Daemon
