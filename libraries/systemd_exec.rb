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

module Systemd
  # rubocop: disable ModuleLength
  module Exec
    OPTIONS ||= %w(
      WorkingDirectory
      RootDirectory
      User
      Group
      SupplementaryGroups
      Nice
      OOMScoreAdjust
      IOSchedulingClass
      IOSchedulingPriority
      CPUSchedulingPolicy
      CPUSchedulingPriority
      CPUSchedulingResetOnFork
      CPUAffinity
      UMask
      Environment
      EnvironmentFile
      StandardInput
      StandardOutput
      StandardError
      TTYPath
      TTYReset
      TTYVHangup
      TTYVTDisallocate
      SyslogIdentifier
      SyslogFacility
      SyslogLevel
      SyslogLevelPrefix
      TimerSlackNSec
      LimitCPU
      LimitFSIZE
      LimitDATA
      LimitSTACK
      LimitCORE
      LimitRSS
      LimitNOFILE
      LimitAS
      LimitNPROC
      LimitMEMLOCK
      LimitLOCKS
      LimitSIGPENDING
      LimitMSGQUEUE
      LimitNICE
      LimitRTPRIO
      LimitRTTIME
      PAMName
      CapabilityBoundingSet
      SecureBits
      Capabilities
      ReadWriteDirectories
      ReadOnlyDirectories
      InaccessibleDirectories
      PrivateTmp
      PrivateDevices
      PrivateNetwork
      ProtectSystem
      ProtectHome
      MountFlags
      UtmpIdentifier
      UtmpMode
      SELinuxContext
      AppArmorProfile
      SmackProcessLabel
      IgnoreSIGPIPE
      NoNewPrivileges
      SystemCallFilter
      SystemCallErrorNumber
      SystemCallArchitectures
      RestrictAddressFamilies
      Personality
      RuntimeDirectory
      RuntimeDirectoryMode
    )

    attribute :supplementary_groups, kind_of: [String, Array]
    attribute :nice, kind_of: Integer, equal_to: -20.upto(19).to_a
    attribute :oom_score_adjust, kind_of: Integer,
                                 equal_to: -1_000.upto(1_000).to_a
    attribute :io_scheduling_class, kind_of: [Integer, String],
                                    equal_to: %w(none realtime best-effort idle)
                                      .concat(0.upto(3).to_a)
    attribute :io_scheduling_priority, kind_of: Integer,
                                       equal_to: 0.upto(7).to_a
    attribute :cpu_scheduling_policy, kind_of: String,
                                      equal_to: %w(other batch idle fifo rr)
    attribute :cpu_scheduling_priority, kind_of: Integer,
                                        equal_to: 1.upto(99).to_a
    attribute :cpu_scheduling_reset_on_fork, kind_of: [TrueClass, FalseClass]
    attribute :cpu_affinity, kind_of: Integer
    attribute :environment, kind_of: Hash
    attribute :standard_input, kind_of: String,
                               equal_to: %w(null tty tty-force tty-fail socket)
    attribute :standard_output, kind_of: String,
                                equal_to: %w(
                                  inherit journal syslog kmsg journal+console
                                  syslog+console kmsg+console socket null tty
                                )
    attribute :standard_error, kind_of: String,
                               equal_to: %w(
                                 inherit journal syslog kmsg journal+console
                                 syslog+console kmsg+console socket null tty
                               )
    attribute :tty_reset, kind_of: [TrueClass, FalseClass]
    attribute :ttyv_hangup, kind_of: [TrueClass, FalseClass]
    attribute :ttyvt_disallocate, kind_of: [TrueClass, FalseClass]
    attribute :syslog_facility, kind_of: String,
                                equal_to: %w(
                                  kern user mail daemon auth syslog lpr news
                                  uucp cron authpriv ftp local0 local1 local2
                                  local3 local4 local5 local6 local7
                                )
    attribute :syslog_level, kind_of: String,
                             equal_to: %w(
                               emerg alert crit debug
                               warning notice info err
                             )
    attribute :syslog_level_prefix, kind_of: [TrueClass, FalseClass]
    attribute :timer_slack_n_sec, kind_of: [Integer, String]
    attribute :secure_bits, kind_of: [String, Array], callbacks: {
      'valid opts' => lamda do |spec|
        Array(spec).all? do |o|
          %w(
            keep-caps keep-caps-locked
            no-setuid-fixup noroot
            no-setuid-fixup-locked
            noroot-locked
          ).include?(o)
        end
      end
    }
    attribute :read_write_directories, kind_of: [String, Array]
    attribute :read_only_directories, kind_of: [String, Array]
    attribute :innaccessible_directories, kind_of: [String, Array]
    attribute :private_tmp, kind_of: [TrueClass, FalseClass]
    attribute :private_devices, kind_of: [TrueClass, FalseClass]
    attribute :private_network, kind_of: [TrueClass, FalseClass]
    attribute :protect_system, kind_of: [TrueClass, FalseClass, String],
                               equal_to: [true, false, 'full']
    attribute :protect_home, kind_of: [TrueClass, FalseClass, String],
                             equal_to: [true, false, 'read-only']
    attribute :mount_flags, kind_of: String, equal_to: %w(shared slave private)
    attribute :utmp_mode, kind_of: String, equal_to: %w(init login user)
    attribute :ignore_sigpipe, kind_of: [TrueClass, FalseClass]
    attribute :no_new_privileges, kind_of: [TrueClass, FalseClass]
    attribute :system_call_filter, kind_of: [String, Array]
    attribute :personality, kind_of: String, equal_to: %w(x86 x86-64)
    attribute :runtime_directory, kind_of: [String, Array]
    attribute :runtime_directory_mode, kind_of: [String, Array]
  end
  # rubocop: enable ModuleLength
end
