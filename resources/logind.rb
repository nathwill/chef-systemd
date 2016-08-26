include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_logind
provides :systemd_logind

option_properties Systemd::Logind::OPTIONS

default_action :create

%w( create delete ).map(&:to_sym).each do |actn|
  action actn do
    conf_d = '/etc/systemd/logind.conf.d'

    directory conf_d do
      not_if { actn == :delete }
    end

    r = systemd_unit "logind-#{new_resource.name}" do
      content property_hash(Systemd::Logind::OPTIONS)
      action :nothing
    end

    file "#{conf_d}/#{new_resource.name}.conf" do
      content r.to_ini
      action actn
    end
  end
end
