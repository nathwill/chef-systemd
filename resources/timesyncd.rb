def self.daemon_type
  :timesyncd
end

include SystemdCookbook::ResourceFactory::Daemon
