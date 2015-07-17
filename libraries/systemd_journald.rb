# http://www.freedesktop.org/software/systemd/man/journald.conf.html
module Systemd
  module Journald
    OPTIONS ||= %w(
      Storage
			Compress
			Seal
			SplitMode
			RateLimitInterval
			RateLimitBurst
			SystemMaxUse
			SystemKeepFree
			SystemMaxFileSize
			RuntimeMaxUse
			RuntimeKeepFree
			RuntimeMaxFileSize
			MaxFileSec
			MaxRetentionSec
			SyncIntervalSec
			ForwardToSyslog
			ForwardToKMsg
			ForwardToConsole
			ForwardToWall
			MaxLevelStore
			MaxLevelSyslog
			MaxLevelKMsg
			MaxLevelConsole
			MaxLevelWall
			TTYPath
		)
	end
end
