require_relative 'resource_systemd_unit'
require_relative 'systemd_mount'

class Chef::Resource
  class SystemdMount < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_mount
    provides :systemd_mount

    def unit_type(_ = nil)
      :mount
    end

    Systemd::Mount::OPTIONS.each do |option|
      attribute option.underscore.to_sym, kind_of: String, default: nil
    end

    def mount
      yield
    end
  end
end
