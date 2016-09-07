def self.unit_type
  :automount
end

def unit_type
  :automount
end

include Systemd::Mixins::Unit
include Systemd::Mixins::PropertyHashConversion
include Systemd::Mixins::ResourceFactory::Unit
