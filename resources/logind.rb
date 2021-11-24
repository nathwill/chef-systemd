def self.resource_type
  :logind
end

include SystemdCookbook::ResourceFactory::Misc

unified_mode true

default_action :create
