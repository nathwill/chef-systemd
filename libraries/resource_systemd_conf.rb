require 'chef/resource/lwrp_base'

class Chef::Resource
  class SystemdConf < Chef::Resource::LWRPBase
    self.resource_name = :systemd_conf
    provides :systemd_conf

    actions :create, :delete
    default_action :create

    # define class method for defining resource
    # attributes from the resource module options
    def self.option_attributes(options)
      options.each do |option|
        attribute option.underscore.to_sym, kind_of: String, default: nil
      end
    end

    def options_config(opts)
      opts.reject { |o| send(o.underscore.to_sym).nil? }.map do |opt|
        "#{opt.camelize}=#{send(opt.underscore.to_sym)}"
      end
    end
  end
end
