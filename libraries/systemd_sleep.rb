# http://www.freedesktop.org/software/systemd/man/systemd-sleep.conf.html
module Systemd
  module Sleep
    OPTIONS ||= %w(
      SuspendMode
			HibernateMode
			HybridSleepMode
			SuspendState
			HibernateState
			HybridSleepState
		)
	end
end
