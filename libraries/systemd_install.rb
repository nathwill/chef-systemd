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
