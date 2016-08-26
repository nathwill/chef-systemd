include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_user
provides :systemd_user

option_properties Systemd::User::OPTIONS

default_action :create

%w( create delete ).map(&:to_sym).each do |actn|
  action actn do
    conf_d = '/etc/systemd/user.conf.d'

    directory conf_d do
      not_if { actn == :delete }
    end

    r = systemd_unit "user-#{new_resource.name}" do
      content property_hash(Systemd::User::OPTIONS)
      action :nothing
    end

    file "#{conf_d}/#{new_resource.name}.conf" do
      content r.to_ini
      action actn
    end
  end
end
