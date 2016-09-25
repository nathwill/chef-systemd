def self.unit_type
  :mount
end

include SystemdCookbook::ResourceFactory::DropIn

property :what, SystemdCookbook::Mount::OPTIONS['Mount']['What']
  .merge(required: false)

property :where, SystemdCookbook::Mount::OPTIONS['Mount']['Where']
  .merge(required: false)
