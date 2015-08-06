require_relative 'resource_systemd_daemon'
require_relative 'systemd_timesyncd'

class Chef::Resource
  class SystemdTimesyncd < Chef::Resource::SystemdDaemon
    self.resource_name = :systemd_timesyncd
    provides :systemd_timesyncd

    def daemon_type(_ = nil)
      :timesyncd
    end

    option_attributes Systemd::Timesyncd::OPTIONS
  end
end
