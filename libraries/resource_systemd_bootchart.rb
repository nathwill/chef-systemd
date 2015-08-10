require_relative 'resource_systemd_util'
require_relative 'systemd_bootchart'

class Chef::Resource
  class SystemdBootchart < Chef::Resource::SystemdUtil
    self.resource_name = :systemd_bootchart
    provides :systemd_bootchart

    def conf_type(_ = nil)
      :bootchart
    end

    def label(_ = nil)
      'Bootchart'
    end

    option_attributes Systemd::Bootchart::OPTIONS
  end
end
