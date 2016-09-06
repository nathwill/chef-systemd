include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

Systemd::Helpers.build_unit_resource('service')
