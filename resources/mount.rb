def self.unit_type
  :mount
end

def unit_type
  :mount
end

include Systemd::Mixins::ResourceFactory::Unit
