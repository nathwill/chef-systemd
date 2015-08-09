require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef::Provider
  class SystemdConf < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_daemon
    (Systemd::Helpers::DAEMONS | Systemd::Helpers::UTILS).each do |conf_type|
      provides "systemd_#{conf_type}".to_sym
    end

    %i( create delete ).each do |a|
      action a do
        r = new_resource
        daemon_path = Systemd::Helpers.conf_path(r)

        directory Systemd::Helpers.conf_drop_in_root(r) do
          only_if { r.drop_in }
          not_if { r.action == :delete }
        end

        f = file daemon_path do
          content Systemd::Helpers.ini_config(r.to_hash)
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
