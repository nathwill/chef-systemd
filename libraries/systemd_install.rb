# http://www.freedesktop.org/software/systemd/man/systemd.unit.html
module Systemd
  module Install
    # excluded Alias option due to conflict
    OPTIONS ||= %w(
      WantedBy
      RequiredBy
      Also
      DefaultInstance
    )
  end
end
