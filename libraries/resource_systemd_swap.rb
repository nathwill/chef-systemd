require_relative 'resource_systemd_unit'
require_relative 'systemd_swap'

class Chef::Resource
  class SystemdSwap < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_swap
    provides :systemd_swap

    def conf_type(_ = nil)
      :swap
    end

    option_attributes Systemd::Swap::OPTIONS

    def swap
      yield
    end
  end
end
