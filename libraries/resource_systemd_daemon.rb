require 'chef/resource/lwrp_base'
require_relative 'helpers'

class Chef::Resource
  class SystemdDaemon < Chef::Resource::LWRPBase
    self.resource_name = :systemd_daemon
    provides :systemd_daemon

    actions :create, :delete
    default_action :create

    attribute :daemon_type, kind_of: Symbol, default: :journald, required:true,
                            equal_to: Systemd::Helpers::DAEMONS
    attribute :drop_in, kind_of: [TrueClass, FalseClass], default: false

    # define class method for defining resource
    # attributes from the resource module options
    def self.option_attributes(options)
      options.each do |option|
        attribute option.underscore.to_sym, kind_of: String, default: nil
      end
    end

    def to_hash
      conf = {}

      conf
    end

    alias_method :to_h, :to_hash
  end
end
