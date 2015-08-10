require 'chef/provider/lwrp_base'

class Chef::Provider
  class SystemdTmpfile < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_tmpfile

    %i( create delete ).each do |a|
      action a do
        r = new_resource
        dir = '/etc/tmpfiles.d'
        path = ::File.join(dir, "#{r.name}.conf")

        execute "systemd-tmpfiles-#{r.name}" do
          case a
          when :create
            command "systemd-tmpfiles --create #{path}"
          when :delete
            command "systemd-tmpfiles --clean --remove #{path}"
          end
          action :nothing
          subscribes :run, "file[#{path}]", :immediately
        end

        f = file path do
          content [
            r.type, r.path, r.mode, r.uid, r.gid, r.age, r.argument
          ].join(' ')
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
