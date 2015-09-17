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
    OPTIONS ||= Systemd::ResourceControl::OPTIONS
                .merge(Systemd::Exec::OPTIONS)
                .merge(Systemd::Kill::OPTIONS)
                .merge('Type' => {
                         kind_of: String,
                         equal_to: %w( simple forking oneshot dbus notify idle )
                       },
                       'RemainAfterExit' => {
                         kind_of: [TrueClass, FalseClass]
                       },
                       'GuessMainPID' => {
                         kind_of: [TrueClass, FalseClass]
                       },
                       'PIDFile' => {},
                       'BusName' => {},
                       'BusPolicy' => {},
                       'ExecStart' => {},
                       'ExecStartPre' => {},
                       'ExecStartPost' => {},
                       'ExecReload' => {},
                       'ExecStop' => {},
                       'ExecStopPost' => {},
                       'RestartSec' => { kind_of: [String, Integer] },
                       'TimeoutStartSec' => { kind_of: [String, Integer] },
                       'TimeoutStopSec' => { kind_of: [String, Integer] },
                       'TimeoutSec' => { kind_of: [String, Integer] },
                       'WatchdogSec' => { kind_of: [String, Integer] },
                       'Restart' => {
                         kind_of: String,
                         equal_to: %w(
                           on-success on-failure on-abnormal
                           no on-watchdog on-abort always
                         )
                       },
                       'SuccessExitStatus' => { kind_of: [String, Integer] },
                       'RestartPreventExitStatus' => {
                         kind_of: [String, Integer]
                       },
                       'RestartForceExitStatus' => {
                         kind_of: [String, Integer]
                       },
                       'PermissionsStartOnly' => {
                         kind_of: [TrueClass, FalseClass]
                       },
                       'RootDirectoryStartOnly' => {
                         kind_of: [TrueClass, FalseClass]
                       },
                       'NonBlocking' => { kind_of: [TrueClass, FalseClass] },
                       'NotifyAccess' => {
                         kind_of: String,
                         equal_to: %w( none main all )
                       },
                       'Sockets' => {},
                       'StartLimitInterval' => {},
                       'StartLimitBurst' => {},
                       'StartLimitAction' => {
                         kind_of: String,
                         equal_to: %w(
                           none reboot reboot-force reboot-immediate
                           poweroff poweroff-force poweroff-immediate
                         )
                       },
                       'FailureAction' => {
                         kind_of: String,
                         equal_to: %w(
                           none reboot reboot-force reboot-immediate
                           poweroff poweroff-force poweroff-immediate
                         )
                       },
                       'RebootArgument' => {},
                       'FileDescriptorStoreMax' => { kind_of: Integer }
                      )
  end
end
