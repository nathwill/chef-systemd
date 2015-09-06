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

require_relative 'systemd_mixin'

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
  end

  module Mixin
    module Exec
      def supplementary_groups(arg = nil)
        set_or_return(
          :supplementary_groups, arg,
          kind_of: [String, Array]
        )
      end

      def nice(arg = nil)
        set_or_return(
          :nice, arg,
          kind_of: Integer,
          equal_to: -20.upto(19).to_a
        )
      end

      def oom_score_adjust(arg = nil)
        set_or_return(
          :oom_score_adjust, arg,
          kind_of: Integer,
          equal_to: -1_000.upto(1_000).to_a
        )
      end

      def io_scheduling_class(arg = nil)
        set_or_return(
          :io_scheduling_class, arg,
          kind_of: [Integer, String],
          equal_to: %w(none realtime best-effort idle).concat(0.upto(3).to_a)
        )
      end

      def io_scheduling_priority(arg = nil)
        set_or_return(
          :io_scheduling_priority, arg,
          kind_of: Integer,
          equal_to: 0.upto(7).to_a
        )
      end

      def cpu_scheduling_policy(arg = nil)
        set_or_return(
          :cpu_scheduling_policy, arg,
          kind_of: String,
          equal_to: %w(other batch idle fifo rr)
        )
      end

      def cpu_scheduling_priority(arg = nil)
        set_or_return(
          :cpu_scheduling_priority, arg,
          kind_of: Integer,
          equal_to: 1.upto(99).to_a
        )
      end

      def cpu_scheduling_reset_on_fork(arg = nil)
        set_or_return(
          :cpu_scheduling_reset_on_fork, arg,
          kind_of: [TrueClass, FalseClass]
        )
      end

      def cpu_affinity(arg = nil)
        set_or_return(
          :cpu_affinity, arg,
          kind_of: Integer
        )
      end

      def environment(arg = nil)
        set_or_return(
          :environment, arg,
          kind_of: Hash
        )
      end

      def standard_input(arg = nil)
        set_or_return(
          :standard_input, arg,
          kind_of: String,
          equal_to: %w(null tty tty-force tty-fail socket)
        )
      end

      def standard_output(arg = nil)
        set_or_return(
          :standard_output, arg,
          kind_of: String,
          equal_to: %w(
            inherit journal syslog kmsg journal+console
            syslog+console kmsg+console socket null tty
          )
        )
      end

      def standard_error(arg = nil)
        set_or_return(
          :standard_error, arg,
          kind_of: String,
          equal_to: %w(
            inherit journal syslog kmsg journal+console
            syslog+console kmsg+console socket null tty
          )
        )
      end

      def tty_reset(arg = nil)
        set_or_return(
          :tty_reset, arg,
          kind_of: [TrueClass, FalseClass]
        )
      end

      def ttyv_hangup(arg = nil)
        set_or_return(
          :ttyv_hangup, arg,
          kind_of: [TrueClass, FalseClass]
        )
      end

      def ttyvt_disallocate(arg = nil)
        set_or_return(
          :ttyvt_disallocate, arg,
          kind_of: [TrueClass, FalseClass]
        )
      end

      def syslog_facility(arg = nil)
        set_or_return(
          :syslog_facility, arg,
          kind_of: String,
          equal_to: %w(
            kern user mail daemon auth syslog lpr news
            uucp cron authpriv ftp local0 local1 local2
            local3 local4 local5 local6 local7
          )
        )
      end

      def syslog_level(arg = nil)
        set_or_return(
          :syslog_level, arg,
          kind_of: String,
          equal_to: %w(emerg alert crit debug warning notice info err)
        )
      end

      def syslog_level_prefix(arg = nil)
        set_or_return(
          :syslog_level_prefix, arg,
          kind_of: [TrueClass, FalseClass]
        )
      end

      def timer_slack_n_sec(arg = nil)
        set_or_return(
          :timer_slack_n_sec, arg,
          kind_of: [Integer, String]
        )
      end

      def secure_bits(arg = nil)
        set_or_return(
          :secure_bits, arg, kind_of: [String, Array], callbacks: {
            'valid opts' => lamda do |spec|
              Array(spec).all? do |o|
                %w( keep-caps keep-caps-locked no-setuid-fixup noroot
                    no-setuid-fixup-locked noroot-locked ).include?(o)
              end
            end
          }
        )
      end

      def read_write_directories(arg = nil)
        set_or_return(
          :read_write_directories, arg,
          kind_of: [String, Array]
        )
      end

      def read_only_directories(arg = nil)
        set_or_return(
          :read_only_directories, arg,
          kind_of: [String, Array]
        )
      end

      def inaccessible_directories(arg = nil)
        set_or_return(
          :inaccessible_directories, arg,
          kind_of: [String, Array]
        )
      end

      def private_tmp(arg = nil)
        set_or_return(
          :private_tmp, arg,
          kind_of: [TrueClass, FalseClass]
        )
      end

      def private_devices(arg = nil)
        set_or_return(
          :private_devices, arg,
          kind_of: [TrueClass, FalseClass]
        )
      end

      def private_network(arg = nil)
        set_or_return(
          :private_network, arg,
          kind_of: [TrueClass, FalseClass]
        )
      end

      def protect_system(arg = nil)
        set_or_return(
          :protect_system, arg,
          kind_of: [TrueClass, FalseClass, String],
          equal_to: [true, false, 'full']
        )
      end

      def protect_home(arg = nil)
        set_or_return(
          :protect_home, arg,
          kind_of: [TrueClass, FalseClass, String],
          equal_to: [true, false, 'read-only']
        )
      end

      def mount_flags(arg = nil)
        set_or_return(
          :mount_flags, arg,
          kind_of: String,
          equal_to: %w(shared slave private)
        )
      end

      def utmp_mode(arg = nil)
        set_or_return(
          :utmp_mode, arg,
          kind_of: String,
          equal_to: %w(init login user)
        )
      end

      def ignore_sigpipe(arg = nil)
        set_or_return(
          :ignore_sigpipe, arg,
          kind_of: [TrueClass, FalseClass]
        )
      end

      def no_new_privileges(arg = nil)
        set_or_return(
          :no_new_privileges, arg,
          kind_of: [TrueClass, FalseClass]
        )
      end

      def system_call_filter(arg = nil)
        set_or_return(
          :system_call_filter, arg,
          kind_of: [String, Array]
        )
      end

      def personality(arg = nil)
        set_or_return(
          :personality, arg,
          kind_of: String,
          equal_to: %w(x86 x86-64)
        )
      end

      def runtime_directory(arg = nil)
        set_or_return(
          :runtime_directory, arg,
          kind_of: [String, Array]
        )
      end

      def runtime_directory_mode(arg = nil)
        set_or_return(
          :runtime_directory_mode, arg,
          kind_of: [String, Array]
        )
      end
    end
  end
  # rubocop: enable ModuleLength
end
