def self.daemon_type
  :logind
end

include Systemd::ResourceFactory::Daemon
