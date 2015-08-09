require_relative 'provider_systemd_conf'

class Chef::Provider
  class SystemdDaemon < Chef::Provider::SystemdConf
    provides :systemd_daemon
    Systemd::Helpers::DAEMONS.each do |daemon|
      provides "systemd_#{daemon}".to_sym
    end
  end
end
