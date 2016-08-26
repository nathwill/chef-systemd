include Systemd::Mixins::Unit
include Systemd::Mixins::Iniable

resource_name :systemd_automount
provides :systemd_automount

option_properties Systemd::Automount::OPTIONS

def automount; yield; end

default_action :create

Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
  action actn do
    systemd_unit "#{new_resource.name}.automount" do
      triggers_reload new_resource.triggers_reload
      content property_hash(Systemd::Automount::OPTIONS)
      action actn
    end
  end
end
