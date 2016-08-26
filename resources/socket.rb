include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_socket
provides :systemd_socket

option_properties Systemd::Socket::OPTIONS

def socket
  yield
end

default_action :create

Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
  action actn do
    systemd_unit "#{new_resource.name}.socket" do
      triggers_reload new_resource.triggers_reload
      content property_hash(Systemd::Socket::OPTIONS)
      action actn
    end
  end
end
