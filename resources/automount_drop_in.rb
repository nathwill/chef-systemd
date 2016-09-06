include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

Systemd::Helpers.build_drop_in_resource('automount')

property :where, Systemd::Automount::OPTIONS['Automount']['Where']
  .merge(required: false)
