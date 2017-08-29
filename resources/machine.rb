resource_name :systemd_machine
provides :systemd_machine

property :signal, [String, Integer]
property :kill_who, String
property :service, String, default: lazy { "systemd-nspawn@#{name}.service" }
property :host_path, String
property :machine_path, String

default_action :start

action_class do
  def machine_running?(name)
    require 'dbus/systemd/machined'
    machine = DBus::Systemd::Machined::Machine.new(name)
    machine.properties['State'] == 'running'
  rescue DBus::Error => e
    raise e unless e.name == 'org.freedesktop.machine1.NoSuchMachine'
    false
  end
end

action :start do
  execute "start-machine-#{new_resource.name}" do
    command "machinectl start #{new_resource.name}"
    not_if { machine_running?(new_resource.name) }
  end
end

action :poweroff do
  execute "poweroff-machine-#{new_resource.name}" do
    command "machinectl poweroff #{new_resource.name}"
    only_if { machine_running?(new_resource.name) }
  end
end

action :reboot do
  execute "reboot-machine-#{new_resource.name}" do
    command "machinectl reboot #{new_resource.name}"
  end
end

action :enable do
  systemd_service new_resource.service do
    action :enable
  end
end

action :disable do
  systemd_service new_resource.service do
    action :disable
  end
end

action :terminate do
  execute "terminate-machine-#{new_resource.name}" do
    command "machinectl terminate #{new_resource.name}"
    only_if { machine_running?(new_resource.name) }
  end
end

action :kill do
  cmd = %w(machinectl kill)
  cmd << "--signal=#{new_resource.signal}" if new_resource.signal
  cmd << "--kill-who=#{new_resource.kill_who}" if new_resource.kill_who

  execute "kill-machine-#{new_resource.name}" do
    command "#{cmd.join(' ')} #{new_resource.name}"
  end
end

action :copy_to do
  execute "copy-to-machine-#{new_resource.name}" do
    r = new_resource
    command "machinectl copy-to #{r.name} #{r.host_path} #{r.machine_path}"
  end
end

action :copy_from do
  execute "copy-from-machine-#{new_resource.name}" do
    r = new_resource
    command "machinectl copy-from #{r.name} #{r.machine_path} #{r.host_path}"
  end
end
