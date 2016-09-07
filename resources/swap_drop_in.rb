def self.unit_type
  :swap
end

def unit_type
  :swap
end

include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion
include Systemd::Mixins::ResourceFactory::DropIn

property :what, Systemd::Swap::OPTIONS['Swap']['What']
  .merge(required: false)
