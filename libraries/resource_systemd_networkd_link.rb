require 'chef/mixin/params_validate'
require 'chef/resource/lwrp_base'
require_relative 'systemd_networkd'
require_relative 'helpers'

class Chef::Resource
  class SystemdNetworkdLink < Chef::Resource::LWRPBase
    include Chef::Mixins::ParamsValidate

    self.resource_name = :systemd_networkd_link
    provides :systemd_networkd_link

    actions :create, :delete
    default_action :create

    Systemd::Networkd::OPTIONS.each do |option|
      attribute option.underscore.to_sym, kind_of: String, default: nil
    end

    def match
      yield
    end

    def link
      yield
    end

    def to_hash
      conf = {}

      %i( match link ).each do |s|
        conf[s] = section_values(s)
      end

      conf
    end

    alias_method :to_h, :to_hash

    private

    def section_values(section)
      options_config(Systemd::Networkd.const_get(section.capitalize)::OPTIONS)
    end

    def options_config(opts)
      opts.reject { |o| send(o.underscore.to_sym).nil? }.map do |opt|
        "#{opt.camelize}=#{send(opt.underscore.to_sym)}"
      end
    end
  end
end
