include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

Systemd::Helpers.build_drop_in_unit('timer')
