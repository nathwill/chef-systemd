require_relative 'resource_systemd_conf'

class Chef::Resource
  class SystemdUtil < Chef::Resource::SystemdConf
    self.resource_name = :systemd_util
    provides :systemd_util

    attribute :drop_in, kind_of: [TrueClass, FalseClass], default: true
    attribute :conf_type, kind_of: Symbol, required: true, default: :bootchart,
                          equal_to: Systemd::Helpers::UTILS

    def to_hash
      opts = Systemd.const_get(conf_type.capitalize)::OPTIONS

      conf = {}
      conf[label] = options_config(opts)
      conf
    end

    alias_method :to_h, :to_hash
  end
end
