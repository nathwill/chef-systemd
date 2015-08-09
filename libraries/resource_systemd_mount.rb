require_relative 'resource_systemd_unit'
require_relative 'systemd_mount'

class Chef::Resource
  class SystemdMount < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_mount
    provides :systemd_mount

    def conf_type(_ = nil)
      :mount
    end

    option_attributes Systemd::Mount::OPTIONS

    def mount
      yield
    end
  end
end
