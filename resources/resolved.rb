def self.daemon_type
  :resolved
end

include Systemd::ResourceFactory::Daemon
