require 'dbus/systemd/machined'
require 'dbus/systemd/importd'

resource_name :systemd_machine_image
provides :systemd_machine_image

property :type, equal_to: %w( tar raw ), default: 'tar'
property :source, String
property :verify, String, equal_to: %w( no checksum signature ),
                          default: 'signature'
property :limit_bytes, Integer
property :read_only, [TrueClass, FalseClass], default: false
property :from, String, default: lazy { name }
property :to, String, default: lazy { name }
property :force, [TrueClass, FalseClass], default: false
property :path, String
property :format, equal_to: %( uncompressed xz bzip2 gzip ),
                  default: 'uncompressed'

default_action :pull

action :pull do
  r = new_resource

  ruby_block "pull-machine-image-#{r.name}" do
    importd = DBus::Systemd::Importd::Manager.new
    machined = DBus::Systemd::Machined::Manager.new

    block do
      main = DBus::Main.new
      main << importd.bus

      transfer_id = importd.send(
        "Pull#{r.type.capitalize}".to_sym,
        r.source,
        r.name,
        r.verify,
        r.force
      ).first

      importd.on_signal('TransferRemoved') do |id, _path, result|
        if id == transfer_id
          begin
            if %w( cancel failed ).include?(result)
              raise "Machine image pull #{id} failed: #{result}"
            end
          ensure
            main.quit
          end
        end
      end

      main.run
    end

    only_if do
      r.force || !machined.images.detect { |i| i[:name] == r.name }
    end

    not_if do
      importd.transfers.detect { |t| t[:image_name] == r.name }
    end
  end
end

action :set_properties do
  r = new_resource

  mgr = DBus::Systemd::Machined::Manager.new
  img = mgr.image(r.name)

  ruby_block "set-machine-image-read-only-#{r.name}" do
    block do
      img.MarkReadOnly(r.read_only)
    end

    not_if { r.read_only.nil? }
    only_if { img.properties['ReadOnly'] != r.read_only }
  end

  ruby_block "set-machine-image-limit-bytes-#{r.name}" do
    block do
      img.SetLimit(new_resource.limit_bytes)
    end

    not_if { r.limit_bytes.nil? }
    only_if { img.properties['Limit'] != r.limit_bytes }
  end
end

action :clone do
  r = new_resource

  ruby_block "clone-machine-image-#{r.name}" do
    mgr = DBus::Systemd::Machined::Manager.new

    block do
      mgr.CloneImage(r.from, r.to, r.read_only)
    end

    not_if do
      mgr.images.detect { |img| img[:name] == r.to }
    end
  end
end

action :rename do
  r = new_resource

  ruby_block "rename-machine-image-#{r.name}" do
    mgr = DBus::Systemd::Machined::Manager.new

    block do
      mgr.RenameImage(r.from, r.to)
    end

    not_if do
      mgr.images.detect { |img| img[:name] == r.to }
    end
  end
end

action :remove do
  r = new_resource

  ruby_block "remove-machine-image-#{r.name}" do
    mgr = DBus::Systemd::Machined::Manager.new

    block do
      mgr.RemoveImage(r.name)
    end

    only_if do
      mgr.images.detect { |img| img[:name] == r.name }
    end
  end
end

action :import do
  r = new_resource

  ruby_block "import-machine-image-#{r.name}" do
    importd = DBus::Systemd::Importd::Manager.new
    machined = DBus::Systemd::Machined::Manager.new

    block do
      fd = ::File.open(r.path, 'r')

      importd.send(
        "Import#{r.type.capitalize}".to_sym,
        fd,
        r.name,
        r.force,
        r.read_only
      )
      # TODO: close fd on completion
    end

    only_if do
      r.force || !machined.images.detect { |img| img[:name] == r.name }
    end

    not_if do
      importd.transfers.detect { |t| t[:image_name] == r.name }
    end
  end
end

action :export do
  r = new_resource

  ruby_block "export-machine-image-#{r.name}" do
    importd = DBus::Systemd::Importd::Manager.new

    block do
      fd = ::File.open(r.path, 'w')

      import_mgr.send(
        "Export#{r.type.capitalize}".to_sym,
        r.name,
        fd,
        r.format
      )
      # TODO: close fd on completion
    end

    only_if do
    end

    not_if do
    end
  end
end
