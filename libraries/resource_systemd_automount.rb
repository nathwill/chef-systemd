require_relative 'resource_systemd_unit'
require_relative 'systemd_automount'

class Chef::Resource
  class SystemdAutomount < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_automount
    provides :systemd_automount

    def unit_type(_ = nil)
      :automount
    end

    Systemd::Automount::OPTIONS.each do |option|
      attribute option.underscore.to_sym, kind_of: String, default: nil
    end

    def automount
      yield
    end
  end
end
