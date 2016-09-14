def self.daemon_type
  :journald
end

include Systemd::ResourceFactory::Daemon
