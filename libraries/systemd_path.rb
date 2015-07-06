# http://www.freedesktop.org/software/systemd/man/systemd.path.html
module Systemd
  module Path
    OPTIONS ||= %w(
      PathExists
      PathExistsGlob
      PathChanged
      PathModified
      DirectoryNotEmpty
      Unit
      MakeDirectory
      DirectoryMode
    )
  end
end
