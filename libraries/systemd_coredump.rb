# http://www.freedesktop.org/software/systemd/man/coredump.conf.html
module Systemd
  module Coredump
    OPTIONS ||= %w(
      Storage
      Compress
      ProcessSizeMax
      ExternalSizeMax
      JournalSizeMax
      MaxUse
      KeepFree
    )
  end
end
