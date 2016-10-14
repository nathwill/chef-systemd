require 'dbus/systemd/machined'
require 'dbus/systemd/importd'

resource_name :systemd_machine_image
provides :systemd_machine_image

property :type, equal_to: %w( tar raw ), default: 'tar'
property :source, String
property :path, String
property :size_limit, [String, Integer]
property :read_only, [TrueClass, FalseClass], default: false
property :from, String, default: lazy { name }
property :to, String, default: lazy { name }
property :force, [TrueClass, FalseClass], default: false
property :format, equal_to: %w( uncompressed xz bzip2 gzip )
property :verify, String, equal_to: %w( no checksum signature ),
                          default: 'signature'

default_action :pull

action :pull do
  r = new_resource

  cmd = ['machinectl', "pull-#{r.type}", "--verify=#{r.verify}"]
  cmd << "--force" if r.force

  execute "pull-machine-image-#{r.name}" do
    command "#{cmd.join(' ')} #{r.source} #{r.name}"
    only_if do
      mgr = DBus::Systemd::Machined::Manager.new
      r.force || !mgr.images.detect { |i| i[:name] == r.name }
    end
  end
end

action :set_properties do
  r = new_resource

  execute "set-machine-read-only-#{r.name}" do
    command "machinectl read-only #{r.name} #{r.read_only}"
    not_if { r.read_only.nil? }
    only_if do
      mgr = DBus::Systemd::Machined::Manager.new
      mgr.image(r.name).properties['ReadOnly'] != r.read_only
    end
  end

  execute "set-machine-image-limit-bytes-#{r.name}" do
    command "machinectl set-limit #{r.name} #{r.size_limit}"
    not_if { r.size_limit.nil? }
  end
end

action :clone do
  r = new_resource

  ruby_block "clone-machine-image-#{r.name}" do
    block do
      mgr = DBus::Systemd::Machined::Manager.new
      mgr.CloneImage(r.from, r.to, r.read_only)
    end

    not_if do
      mgr = DBus::Systemd::Machined::Manager.new
      mgr.images.detect { |img| img[:name] == r.to }
    end
  end
end

action :rename do
  r = new_resource

  ruby_block "rename-machine-image-#{r.name}" do
    block do
      mgr = DBus::Systemd::Machined::Manager.new
      mgr.RenameImage(r.from, r.to)
    end

    not_if do
      mgr = DBus::Systemd::Machined::Manager.new
      mgr.images.detect { |img| img[:name] == r.to }
    end
  end
end

action :remove do
  r = new_resource

  ruby_block "remove-machine-image-#{r.name}" do
    block do
      mgr = DBus::Systemd::Machined::Manager.new
      mgr.RemoveImage(r.name)
    end

    only_if do
      mgr = DBus::Systemd::Machined::Manager.new
      mgr.images.detect { |img| img[:name] == r.name }
    end
  end
end

action :import do
  r = new_resource

  cmd = ['machinectl', "import-#{r.type}"]
  cmd << "--format=#{r.format}" if r.format
  cmd << '--read-only' if r.read_only
  cmd << '--force' if r.force

  execute "import-machine-image-#{r.name}" do
    command "#{cmd.join(' ')} #{r.path} #{r.name}"
    only_if do
      mgr = DBus::Systemd::Machined::Manager.new
      r.force || !mgr.images.detect { |i| i[:name] == r.name }
    end
  end
end

action :export do
  r = new_resource

  cmd = ['machinectl', "export-#{r.type}"]
  cmd << "--format=#{r.format}" if r.format
  cmd << '--force' if r.force

  execute "export-machine-image-#{r.name}" do
    command "#{cmd.join(' ')} #{r.name} #{r.path}"
    only_if do
      r.force || !::File.exist?(r.path)
    end
  end
end
