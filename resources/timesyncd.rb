def self.daemon_type
  :timesyncd
end

include Systemd::ResourceFactory::Daemon
