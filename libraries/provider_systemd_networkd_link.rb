require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef::Provider
  class SystemdNetworkdLink < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_networkd_link

    %i( create delete ).each do |a|
      action a do
        r = new_resource
        link_dir = '/etc/systemd/network'

        directory link_dir do
          not_if { r.action == :delete }
        end

        f = file ::File.join(link_dir, "#{r.name}.link") do
          content Systemd::Helpers.ini_config(r.to_hash)
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
