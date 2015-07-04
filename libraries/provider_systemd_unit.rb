
require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef::Provider
  class SystemdUnit < Chef::Provider::LWRPBase
    provides :systemd_unit

    Systemd::Helpers.unit_types.each do |type|
      provides "systemd_#{type}".to_sym
    end

    use_inline_resources

    def whyrun_supported?
      true
    end

    action :create do
      unit_path = ::File.join(
        '/etc/systemd/system',
        "#{new_resource.name}.#{new_resource.unit_type}"
      )

      execute 'reload-sytemd' do
        command 'systemctl daemon-reload'
        action :nothing
        subscribes :run, "file[#{unit_path}]", :immediately
      end

      file unit_path do
        content Systemd::Helpers.ini_config(new_resource)
        action :create
      end
    end

    action :delete do
      unit_path = ::File.join(
        '/etc/systemd/system',
        "#{new_resource.name}.#{new_resource.unit_type}"
      )

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
