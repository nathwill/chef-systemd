
require_relative 'resource_systemd_unit'

class Chef::Resource
  class SystemdService < Chef::Resource::SystemdUnit
    identity_attr :name

    def initialize(name, run_context = nil)
      super
      @resource_name = :systemd_service
      @provider = Chef::Provider::SystemdService
    end

    def type(_ = nil)
      'service'
    end

    def service(arg = nil)
      set_or_return(
        :service, arg,
        :required => true,
        :kind_of => Array,
        :callbacks => {
          'is a valid service configuration' => lambda do |spec|
            Systemd::Helpers.validate_config('service', spec)
          end
        }
      )
    end
  end
end
