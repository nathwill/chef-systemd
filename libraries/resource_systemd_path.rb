require_relative 'resource_systemd_unit'
require_relative 'systemd_path'

class Chef::Resource
  class SystemdPath < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_path
    provides :systemd_path

    def unit_type(_ = nil)
      :path
    end

    Systemd::Path::OPTIONS.each do |option|
      attribute option.underscore.to_sym, kind_of: String, default: nil
    end

    def path
      yield
    end
  end
end
