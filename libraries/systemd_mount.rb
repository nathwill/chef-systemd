# http://www.freedesktop.org/software/systemd/man/systemd.mount.html
require_relative 'systemd_resource_control'
require_relative 'systemd_exec'
require_relative 'systemd_kill'

module Systemd
  module Mount
    OPTIONS ||= Systemd::ResourceControl::OPTIONS |
                Systemd::Exec::OPTIONS |
                Systemd::Kill::OPTIONS | %w(
                  What
                  Where
                  Type
                  Options
                  SloppyOptions
                  DirectoryMode
                  TimeoutSec
                )
  end
end
