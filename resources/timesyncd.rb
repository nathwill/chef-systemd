include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_timesyncd
provides :systemd_timesyncd

option_properties Systemd::Timesyncd::OPTIONS

default_action :create

%w( create delete ).map(&:to_sym).each do |actn|
  action actn do
    conf_d = '/etc/systemd/timesyncd.conf.d'

    directory conf_d do
      not_if { new_resource.action == :delete }
    end

    r = systemd_unit "timesyncd-#{new_resource.name}" do
      content property_hash(Systemd::Timesyncd::OPTIONS)
      action :nothing
    end

    file "#{conf_d}/#{new_resource.name}.conf" do
      content r.to_ini
      action actn
    end
  end
end
