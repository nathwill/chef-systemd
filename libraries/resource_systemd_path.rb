require_relative 'resource_systemd_unit'
require_relative 'systemd_path'

class Chef::Resource
  class SystemdPath < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_path
    provides :systemd_path

    def conf_type(_ = nil)
      :path
    end

    option_attributes Systemd::Path::OPTIONS

    def path
      yield
    end
  end
end
