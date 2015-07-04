
require_relative 'resource_systemd_unit'

class Chef::Resource
  class SystemdService < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_service
    provides :systemd_service

    def unit_type(_ = nil)
      :service
    end
  end
end
