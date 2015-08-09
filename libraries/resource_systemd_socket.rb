require_relative 'resource_systemd_unit'
require_relative 'systemd_socket'

class Chef::Resource
  class SystemdSocket < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_socket
    provides :systemd_socket

    def conf_type(_ = nil)
      :socket
    end

    option_attributes Systemd::Socket::OPTIONS

    def socket
      yield
    end
  end
end
