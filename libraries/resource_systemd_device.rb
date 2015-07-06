require_relative 'resource_systemd_unit'
require_relative 'systemd_device'

class Chef::Resource
  class SystemdDevice < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_device
    provides :systemd_device

    def unit_type(_ = nil)
      :device
    end
  end
end
