

module Systemd
  module Install
    OPTIONS ||= %w(
      Alias=
      WantedBy=
      RequiredBy=
      Also=
      DefaultInstance=
    )
  end
end
