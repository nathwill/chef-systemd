resource_name :systemd_machine_image
provides :systemd_machine_image

property :type, equal_to: %w(tar raw), default: 'tar'
property :source, String
property :path, String
property :size_limit, [String, Integer]
property :read_only, [TrueClass, FalseClass], default: false
property :from, String, default: lazy { name }
property :to, String, default: lazy { name }
property :force, [TrueClass, FalseClass], default: false
property :format, equal_to: %w(uncompressed xz bzip2 gzip)
property :verify, String, equal_to: %w(no checksum signature),
                          default: 'signature'

default_action :pull

action_class do
  def image_exists?(name)
    require 'dbus/systemd/machined'
    mgr = DBus::Systemd::Machined::Manager.new
    !(!mgr.images.detect { |i| i[:name] == name })
  end
end

action :pull do
  cmd = ["machinectl pull-#{new_resource.type} --verify=#{new_resource.verify}"]
  cmd << '--force' if new_resource.force

  execute "pull-machine-image-#{new_resource.name}" do
    command "#{cmd.join(' ')} #{new_resource.source} #{new_resource.name}"
    only_if do
      new_resource.force || !image_exists?(new_resource.name)
    end
  end
end

action :set_properties do
  require 'dbus/systemd/machined'
  execute "set-machine-read-only-#{new_resource.name}" do
    command "machinectl read-only #{new_resource.name} #{new_resource.read_only}"
    not_if { new_resource.read_only.nil? }
    only_if do
      require 'dbus/systemd/machined'
      img = DBus::Systemd::Machined::Image.new(new_resource.name)
      img.properties['ReadOnly'] != new_resource.read_only
    end
  end

  execute "set-machine-image-limit-bytes-#{new_resource.name}" do
    command "machinectl set-limit #{new_resource.name} #{new_resource.size_limit}"
    not_if { new_resource.size_limit.nil? }
  end
end

action :clone do
  require 'dbus/systemd/machined'
  ruby_block "clone-machine-image-#{new_resource.name}" do
    block do
      require 'dbus/systemd/machined'
      mgr = DBus::Systemd::Machined::Manager.new
      mgr.CloneImage(new_resource.from, new_resource.to, new_resource.read_only)
    end
    not_if do
      image_exists?(new_resource.to)
    end
  end
end

action :rename do
  execute "rename-machine-image-#{new_resource.name}" do
    command "machinectl rename #{new_resource.from} #{new_resource.to}"
    only_if do
      image_exists?(new_resource.from)
    end
  end
end

action :remove do
  execute "remove-machine-image-#{new_resource.name}" do
    command "machinectl remove #{new_resource.name}"
    only_if do
      image_exists?(new_resource.name)
    end
  end
end

action :import do
  cmd = ['machinectl', "import-#{new_resource.type}"]
  cmd << "--format=#{new_resource.format}" if new_resource.format
  cmd << '--read-only' if new_resource.read_only
  cmd << '--force' if new_resource.force

  execute "import-machine-image-#{new_resource.name}" do
    command "#{cmd.join(' ')} #{new_resource.path} #{new_resource.name}"
    only_if do
      new_resource.force || !image_exists?(new_resource.name)
    end
  end
end

action :export do
  cmd = ['machinectl', "export-#{new_resource.type}"]
  cmd << "--format=#{new_resource.format}" if new_resource.format
  cmd << '--force' if new_resource.force

  execute "export-machine-image-#{new_resource.name}" do
    command "#{cmd.join(' ')} #{new_resource.name} #{new_resource.path}"
    only_if do
      new_resource.force || !::File.exist?(new_resource.path)
    end
  end
end
