require_relative 'resource_systemd_unit'
require_relative 'systemd_timer'

class Chef::Resource
  class SystemdTimer < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_timer
    provides :systemd_timer

    def conf_type(_ = nil)
      :timer
    end

    option_attributes Systemd::Timer::OPTIONS

    def timer
      yield
    end
  end
end
