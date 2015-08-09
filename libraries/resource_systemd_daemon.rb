require_relative 'resource_systemd_conf'
require_relative 'helpers'

class Chef::Resource
  class SystemdDaemon < Chef::Resource::SystemdConf
    self.resource_name = :systemd_daemon
    provides :systemd_daemon

    attribute :drop_in, kind_of: [TrueClass, FalseClass], default: true
    attribute :conf_type, kind_of: Symbol, required: true, default: :journald,
                          equal_to: Systemd::Helpers::DAEMONS

    def to_hash
      opts = Systemd.const_get(conf_type.capitalize)::OPTIONS

      conf = {}
      conf[label] = options_config(opts)
      conf
    end

    alias_method :to_h, :to_hash
  end
end
