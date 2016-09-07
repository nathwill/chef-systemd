def self.unit_type
  :mount
end

def unit_type
  :mount
end

include Systemd::Mixins::ResourceFactory::DropIn

property :what, Systemd::Mount::OPTIONS['Mount']['What']
  .merge(required: false)

property :where, Systemd::Mount::OPTIONS['Mount']['Where']
  .merge(required: false)
