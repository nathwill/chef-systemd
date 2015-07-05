# http://www.freedesktop.org/software/systemd/man/systemd.kill.html
module Systemd
  module Kill
    OPTIONS ||= %w(
      KillMode
      KillSignal
      SendSIGHUP
      SendSIGKILL
    )
  end
end
