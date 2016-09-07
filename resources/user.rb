def self.daemon_type
  :user
end

def daemon_type
  :user
end

include Systemd::Mixins::ResourceFactory::Daemon
