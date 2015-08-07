# http://www.freedesktop.org/software/systemd/man/timesyncd.conf.html
module Systemd
  module Timesyncd
    OPTIONS ||= %w(
      NTP
      FallbackNTP
    )
  end
end
