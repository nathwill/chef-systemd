
require_relative 'systemd_helpers'

class Chef::Resource
  class SystemdUnit < Chef::Resource
    identity_attr :name

    def initialize(name, run_context = nil)
      super
      @name = name
      @resource_name = :systemd_unit
      @provider = Chef::Provider::SystemdUnit
      @allowed_actions = [:create, :delete]
      @action = :create
    end

    def type(arg = nil)
      set_or_return(
        :type, arg,
        :required => true,
        :kind_of => Symbol,
        :equal_to => Systemd::Helpers.unit_types,
        :default => :service
      )
    end

    def unit(arg = nil)
      set_or_return(
        :unit, arg,
        :required => true,
        :kind_of => Array,
        :callbacks => {
          'is a valid unit configuration' => lambda do |spec|
            Systemd::Helpers.validate_config('unit', spec)
          end
        }
      )
    end

    def install(arg = nil)
      set_or_return(
        :install, arg,
        :required => true,
        :kind_of => Array,
        :callbacks => {
          'is a valid install configuration' => lambda do |spec|
            Systemd::Helpers.validate_config('install', spec)
          end
        }
      )
    end
  end
end
