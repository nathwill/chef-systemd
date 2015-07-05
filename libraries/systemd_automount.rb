# http://www.freedesktop.org/software/systemd/man/systemd.automount.html
module Systemd
  module Automount
    OPTIONS ||= %w(
      Where
      DirectoryMode
      TimeoutIdleSec
    )
  end
end
