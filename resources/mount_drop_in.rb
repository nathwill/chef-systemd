def self.resource_type
  :mount
end

include SystemdCookbook::ResourceFactory::DropIn

property :mount_what, SystemdCookbook::Mount::OPTIONS['Mount']['What']
  .merge(required: false)

property :mount_where, SystemdCookbook::Mount::OPTIONS['Mount']['Where']
  .merge(required: false)

default_action :create
