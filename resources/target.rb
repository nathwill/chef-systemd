include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_target
provides :systemd_target

option_properties Systemd::Target::OPTIONS

def target
  yield
end

default_action :create

Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
  action actn do
    systemd_unit "#{new_resource.name}.target" do
      triggers_reload new_resource.triggers_reload
      content property_hash(Systemd::Target::OPTIONS)
      action actn
    end
  end
end
