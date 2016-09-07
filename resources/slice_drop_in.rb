def self.unit_type
  :slice
end

def unit_type
  :slice
end

include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion
include Systemd::Mixins::ResourceFactory::DropIn
