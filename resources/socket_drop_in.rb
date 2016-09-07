def self.unit_type
  :socket
end

def unit_type
  :socket
end

include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion
include Systemd::Mixins::ResourceFactory::DropIn
