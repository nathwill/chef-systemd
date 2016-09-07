def self.unit_type
  :timer
end

def unit_type
  :timer
end

include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion
include Systemd::Mixins::ResourceFactory::DropIn
