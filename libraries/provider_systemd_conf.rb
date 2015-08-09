require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef::Provider
  class SystemdConf < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_conf

    %i( create delete ).each do |a|
      action a do
        r = new_resource
        conf_path = Systemd::Helpers.conf_path(r)

        directory Systemd::Helpers.conf_drop_in_root(r) do
          only_if { r.drop_in }
          not_if { r.action == :delete }
        end

        execute "#{r.name}.#{r.conf_type}-systemd-reload" do
          command 'systemctl daemon-reload'
          action :nothing
          only_if { r.is_a?(Chef::Resource::SystemdUnit) }
          subscribes :run, "file[#{conf_path}]", :immediately
        end

        f = file conf_path do
          content Systemd::Helpers.ini_config(r.to_hash)
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
