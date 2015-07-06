require_relative 'resource_systemd_unit'
require_relative 'systemd_automount'

class Chef::Resource
  class SystemdAutomount < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_automount
    provides :systemd_automount

    def unit_type(_ = nil)
      :automount
    end

    option_attributes Systemd::Automount::OPTIONS

    def automount
      yield
    end
  end
end
