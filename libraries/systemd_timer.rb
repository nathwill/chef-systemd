# http://www.freedesktop.org/software/systemd/man/systemd.timer.html
module Systemd
  module Timer
    OPTIONS ||= %w(
      OnActiveSec
      OnBootSec
      OnStartupSec
      OnUnitActiveSec
      OnUnitInactiveSec
      OnCalendar
      AccuracySec
      Unit
      Persistent
      WakeSystem
    )
  end
end
