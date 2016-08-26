include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_timer
provides :systemd_timer

option_properties Systemd::Timer::OPTIONS

def timer
  yield
end

default_action :create

Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
  action actn do
    systemd_unit "#{new_resource.name}.timer" do
      triggers_reload new_resource.triggers_reload
      content property_hash(Systemd::Timer::OPTIONS)
      action actn
    end
  end
end
