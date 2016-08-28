include Systemd::Mixins::Unit
include Systemd::Mixins::DropIn
include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_slice_drop_in
provides :systemd_slice_drop_in

option_properties Systemd::Slice::OPTIONS

def slice
  yield
end

default_action :create

%w( create delete ).map(&:to_sym).each do |actn|
  action actn do
    r = new_resource

    conf_d = "/etc/systemd/system/#{r.override}.d"

    directory conf_d do
      not_if { r.action == :delete }
    end

    u = systemd_unit "#{r.override}_drop-in_#{r.name}" do
      content property_hash(Systemd::Slice::OPTIONS)
      action :nothing
    end

    execute 'systemctl daemon-reload' do
      action :nothing
      only_if { r.triggers_reload }
    end

    file "#{conf_d}/#{r.name}.conf" do
      content u.to_ini
      action actn
      notifies :run, 'execute[systemctl daemon-reload]', :immediately
    end
  end
end
