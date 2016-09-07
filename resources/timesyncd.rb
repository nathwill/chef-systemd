def self.daemon_type
  :timesyncd
end

include Systemd::Mixins::ResourceFactory::Daemon
