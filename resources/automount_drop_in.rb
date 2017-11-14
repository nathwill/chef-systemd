def self.resource_type
  :automount
end

include SystemdCookbook::ResourceFactory::DropIn

property :automount_where, SystemdCookbook::Automount::OPTIONS['Automount']['Where']
  .merge(required: false)

default_action :create
