# http://www.freedesktop.org/software/systemd/man/systemd.service.html
#
# Cookbook Name:: systemd
# Module:: Systemd::Service
#
# Copyright 2015 The Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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
