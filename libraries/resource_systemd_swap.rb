require_relative 'resource_systemd_unit'
require_relative 'systemd_swap'

class Chef::Resource
  class SystemdSwap < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_swap
    provides :systemd_swap

    def unit_type(_ = nil)
      :swap
    end

    Systemd::Swap::OPTIONS.each do |option|
      attribute option.underscore.to_sym, kind_of: String, default: nil
    end

    def swap
      yield
    end
  end
end
