def self.daemon_type
  :system
end

include Systemd::Mixins::ResourceFactory::Daemon
