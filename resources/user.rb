def self.daemon_type
  :user
end

include Systemd::ResourceFactory::Daemon
