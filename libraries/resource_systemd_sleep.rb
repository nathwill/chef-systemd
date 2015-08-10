require_relative 'resource_systemd_util'
require_relative 'systemd_sleep'

class Chef::Resource
  class SystemdSleep < Chef::Resource::SystemdUtil
    self.resource_name = :systemd_sleep
    provides :systemd_sleep

    def conf_type(_ = nil)
      :sleep
    end

    def label(_ = nil)
      'Sleep'
    end

    option_attributes Systemd::Sleep::OPTIONS
  end
end
