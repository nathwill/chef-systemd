def self.resource_type
  :swap
end

include SystemdCookbook::ResourceFactory::DropIn

property :swap_what, SystemdCookbook::Swap::OPTIONS['Swap']['What']
  .merge(required: false)

default_action :create
