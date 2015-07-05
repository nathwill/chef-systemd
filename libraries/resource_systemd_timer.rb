require_relative 'resource_systemd_unit'
require_relative 'systemd_timer'

class Chef::Resource
  class SystemdTimer < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_timer
    provides :systemd_timer

    def unit_type(_ = nil)
      :timer
    end

    Systemd::Timer::OPTIONS.each do |option|
      attribute option.underscore.to_sym, kind_of: String, default: nil
    end

    def timer
      yield
    end
  end
end
