require_relative 'resource_systemd_conf'
require_relative 'systemd_resolved'

class Chef::Resource
  class SystemdResolved < Chef::Resource::SystemdConf
    self.resource_name = :systemd_resolved
    provides :systemd_resolved

    def conf_type(_ = nil)
      :resolved
    end

    def label(_ = nil)
      'Resolve'
    end

    option_attributes Systemd::Resolved::OPTIONS
  end
end
