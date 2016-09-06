include Systemd::Mixins::ResourceFactory
include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

build_unit_resource('service')
