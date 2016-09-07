def self.unit_type
  :service
end

include Systemd::Mixins::ResourceFactory::DropIn
