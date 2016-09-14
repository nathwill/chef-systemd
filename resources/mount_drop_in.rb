def self.unit_type
  :mount
end

include Systemd::ResourceFactory::DropIn

property :what, Systemd::Mount::OPTIONS['Mount']['What']
  .merge(required: false)

property :where, Systemd::Mount::OPTIONS['Mount']['Where']
  .merge(required: false)
