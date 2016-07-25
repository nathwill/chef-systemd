resource_name :systemd_journald
provides :systemd_journald

include Systemd::Mixins::Unit
include Systemd::Mixins::Conversion
include Systemd::Mixins::Inify

option_properties Systemd::Journald::OPTIONS

default_action :create

%w( create delete ).map(&:to_sym).each do |actn|
  action actn do
    dir = '/etc/systemd/journald.conf.d'
    path = "#{dir}/#{new_resource.name}.conf"

    directory dir do
      not_if { new_resource.action == :delete }
    end

    file path do
      content to_ini(property_hash(Systemd::Journald::OPTIONS))
      action actn
    end
  end
end
