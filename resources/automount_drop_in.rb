include Systemd::Mixins::ResourceFactory
include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

build_drop_in_resource('automount')

property :where, Systemd::Automount::OPTIONS['Automount']['Where']
  .merge(required: false)
