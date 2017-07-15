def self.resource_type
  :automount
end

include SystemdCookbook::ResourceFactory::Unit
