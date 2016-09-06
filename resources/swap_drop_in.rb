include Systemd::Mixins::ResourceFactory
include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

build_drop_in_resource('swap')
