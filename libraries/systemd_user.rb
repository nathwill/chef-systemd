# http://www.freedesktop.org/software/systemd/man/systemd-system.conf.html
require_relative 'systemd_system'

module Systemd
  module User
    OPTIONS ||= Systemd::System::OPTIONS
  end
end
