require_relative 'resource_systemd_unit'
require_relative 'systemd_service'

class Chef::Resource
  class SystemdService < Chef::Resource::SystemdUnit
    resource_name = :systemd_service
    provides :systemd_service

    def unit_type(_ = nil)
      :service
    end

    option_attributes Systemd::Service::OPTIONS

    def service
      yield
    end
  end
end
