# http://www.freedesktop.org/software/systemd/man/resolved.conf.html
module Systemd
  module Resolved
    OPTIONS ||= %w(
      DNS
      FallbackDNS
      LLMNR
    )
  end
end
