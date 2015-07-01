
require_relative 'provider_systemd_unit'

class Chef::Provider
  class SystemdService < Chef::Provider::SystemdUnit
    # rubocop: disable AbcSize
    def load_current_resource
      @current_resource ||=
        Chef::Resource::SystemdService.new(new_resource.name)
      @current_resource.type new_resource.type
      @current_resource.unit new_resource.unit
      @current_resource.install new_resource.install
      @current_resource.service new_resource.service
      @current_resource
    end
    # rubocop: enable AbcSize
  end
end
