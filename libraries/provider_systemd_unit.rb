
require 'chef/resource/file'
require_relative 'systemd_helpers'
require_relative 'resource_systemd_unit'

class Chef::Provider
  class SystemdUnit < Chef::Provider
    def initialize(*args)
      super
      @unit_file = Chef::Resource::File.new(
        "systemd-#{new_resource.type}-unit-#{new_resource.name}",
        run_context
      )
    end

    # rubocop: disable AbcSize
    def load_current_resource
      @current_resource ||= Chef::Resource::SystemdUnit.new(new_resource.name)
      @current_resource.type new_resource.type
      @current_resource.unit new_resource.unit
      @current_resource.install new_resource.install
      @current_resource
    end
    # rubocop: enable AbcSize

    def action_create
      new_resource.updated_by_last_action(edit_unit(:create))
    end

    def action_delete
      new_resource.updated_by_last_action(edit_unit(:delete))
    end

    private

    def edit_unit(exec_action)
      @unit_file.mode '0640'
      @unit_file.path ::File.join(
        '/etc/systemd/system',
        "#{@current_resource.name}.#{@current_resource.type}"
      )
      @unit_file.content Systemd::Helpers.ini_config(@current_resource)
      @unit_file.run_action exec_action
      @unit_file.updated_by_last_action?
    end
  end
end
