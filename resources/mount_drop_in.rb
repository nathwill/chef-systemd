include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion

Systemd::Helpers.build_drop_in_resource('mount')

property :what, Systemd::Mount::OPTIONS['Mount']['What']
  .merge(required: false)

property :where, Systemd::Mount::OPTIONS['Mount']['Where']
  .merge(required: false)
