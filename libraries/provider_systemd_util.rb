require_relative 'provider_systemd_conf'

class Chef::Provider
  class SystemdUtil < Chef::Provider::SystemdConf
    Systemd::Helpers::UTILS.each do |util|
      provides "systemd_#{util}".to_sym
    end
  end
end
