def self.unit_type
  :swap
end

include Systemd::Mixins::ResourceFactory::DropIn

property :what, Systemd::Swap::OPTIONS['Swap']['What']
  .merge(required: false)
