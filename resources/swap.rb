include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_swap
provides :systemd_swap

option_properties Systemd::Swap::OPTIONS

def swap
  yield
end

default_action :create

Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
  action actn do
    systemd_unit "#{new_resource.name}.swap" do
      triggers_reload new_resource.triggers_reload
      content property_hash(Systemd::Swap::OPTIONS)
      action actn
    end
  end
end
