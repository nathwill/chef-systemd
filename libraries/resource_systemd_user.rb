require_relative 'resource_systemd_util'
require_relative 'systemd_user'

class Chef::Resource
  class SystemdUser < Chef::Resource::SystemdUtil
    self.resource_name = :systemd_user
    provides :systemd_user

    def conf_type(_ = nil)
      :user
    end

    def label(_ = nil)
      'Manager'
    end

    option_attributes Systemd::User::OPTIONS
  end
end
