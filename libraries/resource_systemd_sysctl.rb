require 'chef/resource/lwrp_base'

class Chef::Resource
  class SystemdSysctl < Chef::Resource::LWRPBase
    self.resource_name = :systemd_sysctl

    provides :systemd_sysctl

    actions :create, :delete
    default_action :create

    attribute :value, kind_of: [String, Number], default: nil
  end
end
