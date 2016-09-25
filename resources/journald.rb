def self.daemon_type
  :journald
end

include SystemdCookbook::ResourceFactory::Daemon
