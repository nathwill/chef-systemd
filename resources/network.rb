resource_name :systemd_network
provides :systemd_network

include SystemdCookbook::Mixin::PropertyHashConversion
include SystemdCookbook::Mixin::DSL

option_properties SystemdCookbook::Network::OPTIONS

default_action :create

%w( create delete ).map(&:to_sym).each do |actn|
  action actn do
    conf_d = '/etc/systemd/network'

    directory conf_d do
      not_if { new_resource.action == :delete }
    end

    u = systemd_unit "#{new_resource.name}.network" do
      content property_hash(SystemdCookbook::Network::OPTIONS)
    end

    file "#{conf_d}/#{u.name}" do
      content u.to_ini
      action new_resource.action
    end
  end
end
