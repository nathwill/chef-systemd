include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_mount
provides :systemd_mount

option_properties Systemd::Mount::OPTIONS

def mount; yield; end

default_action :create

Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
  action actn do
    systemd_unit "#{new_resource.name}.mount" do
      triggers_reload new_resource.triggers_reload
      content property_hash(Systemd::Mount::OPTIONS)
      action actn
    end
  end
end
