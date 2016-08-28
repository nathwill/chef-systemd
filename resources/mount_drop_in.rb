include Systemd::Mixins::Unit
include Systemd::Mixins::DropIn
include Systemd::Mixins::PropertyHashConversion

resource_name :systemd_mount_drop_in
provides :systemd_mount_drop_in

option_properties Systemd::Mount::OPTIONS

property :what, Systemd::Mount::OPTIONS['Mount']['What']
                .merge(required: false)

property :where, Systemd::Mount::OPTIONS['Mount']['Where']
                 .merge(required: false)

def mount
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
      content property_hash(Systemd::Mount::OPTIONS)
      action :nothing
    end

    execute 'systemctl daemon-reload' do
      only_if { r.triggers_reload }
      action :nothing
    end

    file "#{conf_d}/#{r.name}.conf" do
      content u.to_ini
      action actn
      notifies :run, 'execute[systemctl daemon-reload]', :immediately
    end
  end
end
