def self.daemon_type
  :resolved
end

include Systemd::Mixins::ResourceFactory::Daemon
