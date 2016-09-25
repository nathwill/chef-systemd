def self.unit_type
  :automount
end

include SystemdCookbook::ResourceFactory::DropIn

property :where, SystemdCookbook::Automount::OPTIONS['Automount']['Where']
  .merge(required: false)
