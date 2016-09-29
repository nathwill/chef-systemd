resources :systemd_machine_image
provides :systemd_machine_image

property :type, equal_to: %w( tar raw ), default: 'tar'
property :source, String
property :verify, String, equal_to: %w( no checksum signature )
property :limit, [String, Integer]
property :read_only, [TrueClass, FalseClass]
property :from, String
property :to, String, default: lazy { name }
property :force, [TrueClass, FalseClass]
property :path, String

default_action :pull

action :pull do

end

action :clone do

end

action :rename do

end

action :remove do

end

action :import do

end

action :export do

end
