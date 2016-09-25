def self.unit_type
  :swap
end

include SystemdCookbook::ResourceFactory::DropIn

property :what, SystemdCookbook::Swap::OPTIONS['Swap']['What']
  .merge(required: false)
