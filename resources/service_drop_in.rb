def self.unit_type
  :service
end

def unit_type
  :service
end

include Systemd::Mixins::ResourceFactory::DropIn
