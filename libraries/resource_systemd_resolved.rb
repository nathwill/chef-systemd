require_relative 'resource_systemd_daemon'
require_relative 'systemd_resolved'

class Chef::Resource
  class SystemdResolved < Chef::Resource::SystemdDaemon
    self.resource_name = :systemd_resolved
    provides :systemd_resolved

    def daemon_type(_ = nil)
      :resolved
    end

    def label(_ = nil)
      'Resolve'
    end

    option_attributes Systemd::Resolved::OPTIONS
  end
end
