require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef::Provider
  class SystemdUnit < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_unit
    Systemd::Helpers.unit_types.each do |unit_type|
      provides "systemd_#{unit_type}".to_sym
    end

    action :create do
      unit_path = Systemd::Helpers.unit_path(new_resource)

      directory Systemd::Helpers.drop_in_root(new_resource) do
        only_if { new_resource.drop_in }
      end

      execute 'reload-sytemd' do
        command 'systemctl daemon-reload'
        action :nothing
        subscribes :run, "file[#{unit_path}]", :immediately
      end

      file unit_path do
        content Systemd::Helpers.ini_config(new_resource.to_hash)
        action :create
      end
    end

    action :delete do
      unit_path = Systemd::Helpers.unit_path(new_resource)

      execute 'reload-sytemd' do
        command 'systemctl daemon-reload'
        action :nothing
        subscribes :run, "file[#{unit_path}]", :immediately
      end

      file unit_path do
        action :delete
      end
    end
  end
end
