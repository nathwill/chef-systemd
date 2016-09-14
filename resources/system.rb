def self.daemon_type
  :system
end

include Systemd::ResourceFactory::Daemon
