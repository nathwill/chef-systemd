def self.daemon_type
  :journald
end

include Systemd::Mixins::ResourceFactory::Daemon
