def self.unit_type
  :mount
end

def unit_type
  :mount
end

include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion
include Systemd::Mixins::ResourceFactory::Unit
