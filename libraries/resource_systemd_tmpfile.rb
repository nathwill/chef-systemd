require 'chef/resource/lwrp_base'

class Chef::Resource
  class SystemdTmpfile < Chef::Resource::LWRPBase
    self.resource_name = :systemd_tmpfile

    provides :systemd_tmpfile

    actions :create, :delete
    default_action :create

    attribute :path, kind_of: String, required: true, default: nil
    attribute :mode, kind_of: [String, Numeric], required: true, default: '-'
    attribute :uid, kind_of: String, required: true, default: '-'
    attribute :gid, kind_of: String, required: true, default: '-'
    attribute :age, kind_of: String, required: true, default: '-'
    attribute :argument, kind_of: String, required: true, default: '-'
    attribute :type, kind_of: String, required: true, default: 'f',
                     equal_to: %w( 
                       f F w d D v p,p+ L,L+ c,c+ b,b+
                       C x X r R z Z t T h H a,a+ A,A+
                     )
  end
end
