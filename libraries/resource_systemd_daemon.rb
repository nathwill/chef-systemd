require 'chef/resource/lwrp_base'
require_relative 'helpers'

class Chef::Resource
  class SystemdDaemon < Chef::Resource::LWRPBase
    self.resource_name = :systemd_daemon
    provides :systemd_daemon

    actions :create, :delete
    default_action :create

    attribute :drop_in, kind_of: [TrueClass, FalseClass], default: false
    attribute :daemon_type, kind_of: Symbol, default: :journald, required: true,
                            equal_to: Systemd::Helpers::DAEMONS

    # define class method for defining resource
    # attributes from the resource module options
    def self.option_attributes(options)
      options.each do |option|
        attribute option.underscore.to_sym, kind_of: String, default: nil
      end
    end

    def to_hash
      opts = Systemd.const_get(daemon_type.to_s.delete('_').capitalize)::OPTIONS

      conf = {}
      conf[label] = options_config(opts)
      conf
    end

    def options_config(opts)
      opts.reject { |o| send(o.underscore.to_sym).nil? }.map do |opt|
        "#{opt.camelize}=#{send(opt.underscore.to_sym)}"
      end
    end

    alias_method :to_h, :to_hash
  end
end
