require_relative 'resource_systemd_unit'
require_relative 'systemd_socket'

class Chef::Resource
  class SystemdSocket < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_socket
    provides :systemd_socket

    def unit_type(_ = nil)
      :socket
    end

    Systemd::Socket::OPTIONS.each do |option|
      attribute option.underscore.to_sym, kind_of: String, default: nil
    end

    def socket
      yield
    end
  end
end
