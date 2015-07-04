module Systemd
  module Install
    OPTIONS ||= %w(
      Alias # this conflicts with "alias" method :/
      WantedBy
      RequiredBy
      Also
      DefaultInstance
    )
  end
end
