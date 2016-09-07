def self.daemon_type
  :logind
end

def daemon_type
  :logind
end

include Systemd::Mixins::ResourceFactory::Daemon
