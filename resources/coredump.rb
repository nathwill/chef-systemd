resource_name :systemd_coredump
provides :systemd_coredump

include Systemd::Mixins::Unit
include Systemd::Mixins::Conversion
include Systemd::Mixins::Inify

option_properties Systemd::Coredump::OPTIONS

default_action :create

%w( create delete ).map(&:to_sym).each do |actn|
  action actn do
    dir = '/etc/systemd/coredump.conf.d'
    path = "#{dir}/#{new_resource.name}.conf"

    directory dir do
      not_if { new_resource.action == :delete }
    end

    file path do
      content to_ini(property_hash(Systemd::Coredump::OPTIONS))
      action actn
    end
  end
end
