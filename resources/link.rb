resource_name :systemd_link
provides :systemd_link

def self.resource_type
  :link
end

def resource_type
  self.class.resource_type
end

include SystemdCookbook::Mixin::PropertyHashConversion
include SystemdCookbook::Mixin::DSL

option_properties SystemdCookbook::Link::OPTIONS

default_action :create

%w(create delete).map(&:to_sym).each do |actn|
  action actn do
    conf_d = '/etc/systemd/network'

    directory conf_d do
      not_if { new_resource.action == :delete }
    end

    u = systemd_unit "#{new_resource.name}.link" do
      content property_hash(SystemdCookbook::Link::OPTIONS)
    end

    file "#{conf_d}/#{u.name}" do
      content u.to_ini
      action new_resource.action
    end
  end
end
