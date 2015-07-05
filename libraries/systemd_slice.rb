# http://www.freedesktop.org/software/systemd/man/systemd.slice.html
require_relative 'systemd_resource_control'

module Systemd
  module Slice
    OPTIONS ||= Systemd::ResourceControl::OPTIONS
  end
end
