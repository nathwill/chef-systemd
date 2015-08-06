# http://www.freedesktop.org/software/systemd/man/journal-remote.conf.html
module Systemd
  module JournalRemote
    OPTIONS ||= %w(
      SplitMode
      ServerKeyFile
      ServerCertificateFile
      TrustedCertificateFile
    )
  end
end
