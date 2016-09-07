def self.daemon_type
  :system
end

def daemon_type
  :system
end

include Systemd::Mixins::ResourceFactory::Daemon
