# http://www.freedesktop.org/software/systemd/man/systemd.exec.html
#
# Cookbook Name:: systemd
# Module:: Systemd::Exec
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

# rubocop: disable ModuleLength
module Systemd
  module Exec
    OPTIONS ||= {
      'WorkingDirectory' => {},
      'RootDirectory' => {},
      'User' => {},
      'Group' => {},
      'SupplementaryGroups' => { kind_of: [String, Array] },
      'Nice' => { kind_of: Integer, equal_to: -20.upto(19).to_a },
      'OOMScoreAdjust' => {
        kind_of: Integer,
        equal_to: -1_000.upto(1_000).to_a
      },
      'IOSchedulingClass' => {
        kind_of: [Integer, String],
        equal_to: %w(none realtime best-effort idle).concat(0.upto(3).to_a)
      },
      'IOSchedulingPriority' => { kind_of: Integer, equal_to: 0.upto(7).to_a },
      'CPUSchedulingPolicy' => {
        kind_of: String,
        equal_to: %w( other batch idle fifo rr )
      },
      'CPUSchedulingPriority' => {
        kind_of: Integer,
        equal_to: 1.upto(99).to_a
      },
      'CPUSchedulingResetOnFork' => { kind_of: [TrueClass, FalseClass] },
      'CPUAffinity' => { kind_of: Integer },
      'UMask' => {},
      'Environment' => { kind_of: Hash },
      'EnvironmentFile' => {},
      'StandardInput' => {
        kind_of: String,
        equal_to: %w( null tty tty-force tty-fail socket )
      },
      'StandardOutput' => {
        kind_of: String,
        equal_to: %w(
          inherit journal syslog kmsg journal+console
          syslog+console kmsg+console socket null tty
        )
      },
      'StandardError' => {
        kind_of: String,
        equal_to: %w(
          inherit journal syslog kmsg journal+console
          syslog+console kmsg+console socket null tty
        )
      },
      'TTYPath' => {},
      'TTYReset' => { kind_of: [TrueClass, FalseClass] },
      'TTYVHangup' => { kind_of: [TrueClass, FalseClass] },
      'TTYVTDisallocate' => { kind_of: [TrueClass, FalseClass] },
      'SyslogIdentifier' => {},
      'SyslogFacility' => {
        kind_of: String,
        equal_to: %w(
          kern user mail daemon auth syslog lpr news
          uucp cron authpriv ftp local0 local1 local2
          local3 local4 local5 local6 local7
        )
      },
      'SyslogLevel' => {
        kind_of: String,
        equal_to: %w( emerg alert crit debug warning notice info err )
      },
      'SyslogLevelPrefix' => { kind_of: [TrueClass, FalseClass] },
      'TimerSlackNSec' => { kind_of: [Integer, String] },
      'LimitCPU' => {},
      'LimitFSIZE' => {},
      'LimitDATA' => {},
      'LimitSTACK' => {},
      'LimitCORE' => {},
      'LimitRSS' => {},
      'LimitNOFILE' => {},
      'LimitAS' => {},
      'LimitNPROC' => {},
      'LimitMEMLOCK' => {},
      'LimitLOCKS' => {},
      'LimitSIGPENDING' => {},
      'LimitMSGQUEUE' => {},
      'LimitNICE' => {},
      'LimitRTPRIO' => {},
      'LimitRTTIME' => {},
      'PAMName' => {},
      'CapabilityBoundingSet' => {},
      'SecureBits' => {
        kind_of: [String, Array],
        callbacks: {
          'valid opts' => lambda do |spec|
            Array(spec).all? do |o|
              %w( keep-caps keep-caps-locked no-setuid-fixup noroot
                  no-setuid-fixup-locked noroot-locked ).include?(o)
            end
          end
        }
      },
      'Capabilities' => {},
      'ReadWriteDirectories' => { kind_of: [String, Array] },
      'ReadOnlyDirectories' => { kind_of: [String, Array] },
      'InaccessibleDirectories' => { kind_of: [String, Array] },
      'PrivateTmp' => { kind_of: [TrueClass, FalseClass] },
      'PrivateDevices' => { kind_of: [TrueClass, FalseClass] },
      'PrivateNetwork' => { kind_of: [TrueClass, FalseClass] },
      'ProtectSystem' => {
        kind_of: [TrueClass, FalseClass, String],
        equal_to: [true, false, 'full']
      },
      'ProtectHome' => {
        kind_of: [TrueClass, FalseClass, String],
        equal_to: [true, false, 'read-only']
      },
      'MountFlags' => {
        kind_of: String,
        equal_to: %w( shared slave private )
      },
      'UtmpIdentifier' => {},
      'UtmpMode' => { kind_of: String, equal_to: %w( init login user ) },
      'SELinuxContext' => {},
      'AppArmorProfile' => {},
      'SmackProcessLabel' => {},
      'IgnoreSIGPIPE' => { kind_of: [TrueClass, FalseClass] },
      'NoNewPrivileges' => { kind_of: [TrueClass, FalseClass] },
      'SystemCallFilter' => { kind_of: [String, Array] },
      'SystemCallErrorNumber' => {},
      'SystemCallArchitectures' => {},
      'RestrictAddressFamilies' => {},
      'Personality' => { kind_of: String, equal_to: %w( x86 x86-64 ) },
      'RuntimeDirectory' => { kind_of: [String, Array] },
      'RuntimeDirectoryMode' => { kind_of: [String, Array] }
    }
  end
end
# rubocop: enable ModuleLength
