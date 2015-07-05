module Systemd
  module Service
    OPTIONS ||= %w(
      Type
      RemainAfterExit
      GuessMainPID
      PIDFile
      BusName
      BusPolicy
      ExecStart
      ExecStartPre
      ExecStartPost
      ExecReload
      ExecStop
      ExecStopPost
      RestartSec
      TimeoutStartSec
      TimeoutStopSec
      TimeoutSec
      WatchdogSec
      Restart
      SuccessExitStatus
      RestartPreventExitStatus
      RestartForceExitStatus
      PermissionsStartOnly
      RootDirectoryStartOnly
      NonBlocking
      NotifyAccess
      Sockets
      StartLimitInterval
      StartLimitBurst
      StartLimitAction
      FailureAction
      RebootArgument
      FileDescriptorStoreMax
    )
  end
end
