resource_name :systemd_nspawn
provides :systemd_nspawn

def self.resource_type
  :nspawn
end

def resource_type
  self.class.resource_type
end

include SystemdCookbook::Mixin::PropertyHashConversion
include SystemdCookbook::Mixin::DSL

option_properties SystemdCookbook::Nspawn::OPTIONS

default_action :create

%w(create delete).map(&:to_sym).each do |actn|
  action actn do
    conf_d = '/etc/systemd/nspawn'

    directory conf_d do
      not_if { new_resource.action == :delete }
    end

    u = systemd_unit "#{new_resource.name}.nspawn" do
      content property_hash(SystemdCookbook::Nspawn::OPTIONS)
    end

    file "#{conf_d}/#{u.name}" do
      content u.to_ini
      action new_resource.action
    end
  end
end
