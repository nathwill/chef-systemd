require_relative 'resource_systemd_conf'
require_relative 'systemd_journald'

class Chef::Resource
  class SystemdJournald < Chef::Resource::SystemdConf
    self.resource_name = :systemd_journald
    provides :systemd_journald

    def conf_type(_ = nil)
      :journald
    end

    def label(_ = nil)
      'Journal'
    end

    option_attributes Systemd::Journald::OPTIONS
  end
end
