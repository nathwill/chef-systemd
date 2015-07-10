require 'chef/provider/lwrp_base'
require 'mixlib/shellout'
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

    %i( create delete ).each do |a|
      action a do
        r = new_resource
        unit_path = Systemd::Helpers.unit_path(r)

        directory Systemd::Helpers.drop_in_root(r) do
          only_if { r.drop_in }
          not_if { r.action == :delete }
        end

        execute "#{r.name}.#{r.unit_type}-systemd-reload" do
          command 'systemctl daemon-reload'
          action :nothing
          subscribes :run, "file[#{unit_path}]", :immediately
        end

        f = file unit_path do
          content Systemd::Helpers.ini_config(r.to_hash)
          action r.action
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end

    %i( enable disable start stop ).each do |a|
      action a do
        r = new_resource

        unless defined?(ChefSpec)
          state = case a
                  when :enable, :disable
                    Mixlib::ShellOut.new(
                      "systemctl is-enabled #{r.name}.#{r.unit_type}"
                    ).tap(&:run_command).stdout.chomp
                  when :start, :stop
                    Mixlib::ShellOut.new(
                      "systemctl is-active #{r.name}.#{r.unit_type}"
                    ).tap(&:run_command).stdout.chomp
                  end

          match = case a
                  when :enable
                    state == 'enabled'
                  when :disable
                    state == 'disabled'
                  when :start
                    state == 'active'
                  when :stop
                    state == 'inactive'
                  end
        end

        e = execute "systemctl-#{a}-#{r.name}.#{r.unit_type}" do
          command "systemctl #{a} #{r.name}.#{r.unit_type}"
          not_if { match }
        end

        new_resource.updated_by_last_action(e.updated_by_last_action?)
      end
    end
  end
end
