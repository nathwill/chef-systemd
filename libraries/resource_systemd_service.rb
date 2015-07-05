require_relative 'resource_systemd_unit'
require_relative 'systemd_service'

class Chef::Resource
  class SystemdService < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_service
    provides :systemd_service

    def unit_type(_ = nil)
      :service
    end

    Systemd::Service::OPTIONS.each do |option|
      attribute option.underscore.to_sym, kind_of: String, default: nil
    end

    def service
      yield
    end
  end
end
