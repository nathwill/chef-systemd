include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_service
provides :systemd_service

option_properties Systemd::Service::OPTIONS

def service
  yield
end

default_action :create

Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
  action actn do
    systemd_unit "#{new_resource.name}.service" do
      triggers_reload new_resource.triggers_reload
      content property_hash(Systemd::Service::OPTIONS)
      action actn
    end
  end
end
