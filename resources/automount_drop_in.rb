def self.unit_type
  :automount
end

include Systemd::ResourceFactory::DropIn

property :where, Systemd::Automount::OPTIONS['Automount']['Where']
  .merge(required: false)
