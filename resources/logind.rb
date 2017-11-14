def self.resource_type
  :logind
end

include SystemdCookbook::ResourceFactory::Misc

default_action :create
