include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_slice
provides :systemd_slice

option_properties Systemd::Slice::OPTIONS

def slice
  yield
end

default_action :create

Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
  action actn do
    systemd_unit "#{new_resource.name}.slice" do
      triggers_reload new_resource.triggers_reload
      content property_hash(Systemd::Slice::OPTIONS)
      action actn
    end
  end
end
