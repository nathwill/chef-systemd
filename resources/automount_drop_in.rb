def self.unit_type
  :automount
end

include Systemd::Mixins::ResourceFactory::DropIn

property :where, Systemd::Automount::OPTIONS['Automount']['Where']
  .merge(required: false)
