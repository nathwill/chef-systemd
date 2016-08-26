include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_path
provides :systemd_path

option_properties Systemd::Path::OPTIONS

def path
  yield
end

default_action :create

Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
  action actn do
    systemd_unit "#{new_resource.name}.path" do
      triggers_reload new_resource.triggers_reload
      content property_hash(Systemd::Path::OPTIONS)
      action actn
    end
  end
end
