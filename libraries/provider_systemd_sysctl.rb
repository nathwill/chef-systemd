require 'chef/provider/lwrp_base'

class Chef::Provider
  class SystemdSysctl < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_sysctl

    %i( create delete ).each do |a|
      action a do
        r = new_resource
        dir = '/etc/sysctl.d'

        f = file ::File.join(dir, "#{r.name}.conf") do
          content "#{r.name}=#{r.value}" 
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
