require_relative 'resource_systemd_util'
require_relative 'systemd_coredump'

class Chef::Resource
  class SystemdCoredump < Chef::Resource::SystemdUtil
    self.resource_name = :systemd_coredump
    provides :systemd_coredump

    def conf_type(_ = nil)
      :coredump
    end

    def label(_ = nil)
      'Coredump'
    end

    option_attributes Systemd::Coredump::OPTIONS
  end
end
