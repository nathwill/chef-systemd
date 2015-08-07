# http://www.freedesktop.org/software/systemd/man/vconsole.conf.html
module Systemd
  module Vconsole
    OPTIONS ||= %w(
      KEYMAP
      KEYMAP_TOGGLE
      FONT
      FONT_MAP
      FONT_UNIMAP
    )
  end
end
