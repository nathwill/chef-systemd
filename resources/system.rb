include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_system
provides :systemd_system

option_properties Systemd::System::OPTIONS

default_action :create

%w( create delete ).map(&:to_sym).each do |actn|
  action actn do
    conf_d = '/etc/systemd/system.conf.d'

    directory conf_d do
      not_if { actn == :delete }
    end

    r = systemd_unit "system-#{new_resource.name}" do
      content property_hash(Systemd::System::OPTIONS)
      action :nothing
    end

    file "#{conf_d}/#{new_resource.name}.conf" do
      content r.to_ini
      action actn
    end
  end
end
