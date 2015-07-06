# http://www.freedesktop.org/software/systemd/man/systemd.service.html
require_relative 'systemd_resource_control'
require_relative 'systemd_exec'
require_relative 'systemd_kill'

module Systemd
  module Service
    OPTIONS ||= Systemd::ResourceControl::OPTIONS |
                Systemd::Exec::OPTIONS |
                Systemd::Kill::OPTIONS | %w(
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
