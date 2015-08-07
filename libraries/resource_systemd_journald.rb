require_relative 'resource_systemd_daemon'
require_relative 'systemd_journald'

class Chef::Resource
  class SystemdJournald < Chef::Resource::SystemdDaemon
    self.resource_name = :systemd_journald
    provides :systemd_timesyncd

    def daemon_type(_ = nil)
      :journald
    end

    def label(_ = nil)
      'Journal'
    end

    option_attributes Systemd::Journald::OPTIONS
  end
end
