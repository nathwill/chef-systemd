require 'dbus/systemd/machined'

resource_name :systemd_machine
provides :systemd_machine

property :uid, [String, Integer]
property :environment, Hash
property :signal, [String, Integer]
property :kill_who, String
property :bind, String
property :mkdir, [TrueClass, FalseClass], default: true
property :read_only, [TrueClass, FalseClass], default: false

default_action :start

action :start do
  r = new_resource

  execute "start-machine-#{r.name}" do
    command "machinectl start #{r.name}"
    not_if do
      begin
        machine = DBus::Systemd::Machined::Machine.new(r.name)
        machine.properties['State'] == 'running'
      rescue DBus::Error => e
        raise e unless e.name == 'org.freedesktop.machine1.NoSuchMachine'
        false
      end
    end
  end
end

action :enable do
  # do stuff
end

action :disable do
  # do stuff
end

action :poweroff do
  # do stuff
end

action :terminate do
  # do stuff
end

action :kill do
  # do stuff
end

action :bind do
  # do stuff
end
