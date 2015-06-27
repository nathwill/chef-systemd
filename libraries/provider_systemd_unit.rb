

class Chef::Provider
  class SystemdUnit < Chef::Provider
    def initialize(*args)
      super
      @unit_file = Chef::Resource::File.new(
        "systemd-#{new_resource.type}-unit-#{new_resource.name}",
        run_context
      )
    end

    def load_current_resource
      @current_resource ||= Chef::Resource::SystemdUnit.new(new_resource.name)
      @current_resource.type new_resource.type
      @current_resource.unit new_resource.unit
      @current_resource.install new_resource.install
      @current_resource.drop_in new_resource.drop_in
      @current_resource
    end

    def action_create
      new_resource.updated_by_last_action(edit_unit(:create))
    end

    def action_delete
      new_resource.updated_by_last_aciton(edit_unit(:delete))
    end

    private

    def edit_unit(exec_action)

    end
  end
end
