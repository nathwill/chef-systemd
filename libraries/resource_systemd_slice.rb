require_relative 'resource_systemd_unit'
require_relative 'systemd_slice'

class Chef::Resource
  class SystemdSlice < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_slice
    provides :systemd_slice

    def unit_type(_ = nil)
      :slice
    end

    Systemd::Slice::OPTIONS.each do |option|
      attribute option.underscore.to_sym, kind_of: String, default: nil
    end
  end
end
