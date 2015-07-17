# http://www.freedesktop.org/software/systemd/man/logind.conf.html
module Systemd
  module Logind
    OPTIONS ||= %w(
      NAutoVTs
			ReserveVT
			KillUserProcesses
			KillOnlyUsers
			KillExcludeUsers
			IdleAction
			IdleActionSec
			InhibitDelayMaxSec
			HandlePowerKey
			HandleSuspendKey
			HandleHibernateKey
			HandleLidSwitch
			HandleLidSwitchDocked
			PowerKeyIgnoreInhibited
			SuspendKeyIgnoreInhibited
			HibernateKeyIgnoreInhibited
			LidSwitchIgnoreInhibited
			HoldoffTimeoutSec
			RuntimeDirectorySize
			RemoveIPC
		)
  end
end
