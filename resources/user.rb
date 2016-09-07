def self.daemon_type
  :user
end

include Systemd::Mixins::ResourceFactory::Daemon
