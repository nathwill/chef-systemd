require_relative 'resource_systemd_util'
require_relative 'systemd_system'

class Chef::Resource
  class SystemdSystem < Chef::Resource::SystemdUtil
    self.resource_name = :systemd_system
    provides :systemd_system

    def conf_type(_ = nil)
      :system
    end

    def label(_ = nil)
      'Manager'
    end

    option_attributes Systemd::System::OPTIONS
  end
end
