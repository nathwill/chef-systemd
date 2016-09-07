def self.unit_type
  :path
end

def unit_type
  :path
end

include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion
include Systemd::Mixins::ResourceFactory::DropIn
