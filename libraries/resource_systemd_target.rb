require_relative 'resource_systemd_unit'
require_relative 'systemd_target'

class Chef::Resource
  class SystemdTarget < Chef::Resource::SystemdUnit
    resource_name = :systemd_target
    provides :systemd_target

    def unit_type(_ = nil)
      :target
    end
  end
end
