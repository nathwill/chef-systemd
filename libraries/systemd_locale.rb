# http://www.freedesktop.org/software/systemd/man/locale.conf.html
module Systemd
  module Locale
    OPTIONS ||= %w(
       LANG
			 LANGUAGE
			 LC_CTYPE
			 LC_NUMERIC
			 LC_TIME
			 LC_COLLATE
			 LC_MONETARY
			 LC_MESSAGES
			 LC_PAPER
			 LC_NAME
			 LC_ADDRESS
			 LC_TELEPHONE
			 LC_MEASUREMENT
			 LC_IDENTIFICATION
		)
	end
end
