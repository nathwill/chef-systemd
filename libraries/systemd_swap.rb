# http://www.freedesktop.org/software/systemd/man/systemd.swap.html
require_relative 'systemd_resource_control'
require_relative 'systemd_exec'
require_relative 'systemd_kill'

module Systemd
  module Swap
    OPTIONS ||= Systemd::ResourceControl::OPTIONS |
                Systemd::Exec::OPTIONS |
                Systemd::Kill::OPTIONS | %w(
                  What
                  Priority
                  Options
                  TimeoutSec
                )
  end
end
