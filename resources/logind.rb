def self.daemon_type
  :logind
end

include SystemdCookbook::ResourceFactory::Daemon
