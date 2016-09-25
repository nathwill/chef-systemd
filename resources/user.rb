def self.daemon_type
  :user
end

include SystemdCookbook::ResourceFactory::Daemon
