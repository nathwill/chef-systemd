def self.unit_type
  :automount
end

def unit_type
  :automount
end

include Systemd::Mixins::ResourceFactory::Unit
