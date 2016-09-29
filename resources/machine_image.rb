resource_name :systemd_machine_image
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
  # do stuff
end

action :clone do
  # do stuff
end

action :rename do
  # do stuff
end

action :remove do
  # do stuff
end

action :import do
  # do stuff
end

action :export do
  # do stuff
end
