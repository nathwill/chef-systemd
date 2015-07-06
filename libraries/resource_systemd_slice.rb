require_relative 'resource_systemd_unit'
require_relative 'systemd_slice'

class Chef::Resource
  class SystemdSlice < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_slice
    provides :systemd_slice

    def unit_type(_ = nil)
      :slice
    end

    option_attributes Systemd::Slice::OPTIONS
  end
end
