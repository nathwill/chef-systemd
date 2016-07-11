# http://www.freedesktop.org/software/systemd/man/systemd.automount.html
#
# Cookbook Name:: systemd
# Module:: Automount
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

require 'pathname'

module Systemd
  UNIT_TYPES ||= %w(
    automount
    device
    mount
    path
    scope
    service
    slice
    socket
    swap
    target
    timer
  )

  module Common
    ABSOLUTE_PATH ||= {
      kind_of: String,
      callbacks: {
        'is an absolute path' => -> (spec) { Pathname.new(spec).absolute? }
      }
    }.freeze
    SOFT_ABSOLUTE_PATH ||= {
      kind_of: String,
      callbacks: {
        'is an absolute path' => lambda do |spec|
          Pathname.new(spec.gsub(/^\-/, '')).absolute?
        end
      }
    }.freeze
    ARCH ||= {
      kind_of: String,
      equal_to: %w(
        x86
        x86-64
        ppc
        ppc-le
        ppc64
        ppc64-le
        ia64
        parisc
        parisc64
        s390
        s390x
        sparc
        sparc64
        mips
        mips-le
        mips64
        mips64-le
        alpha
        arm
        arm-be
        arm64
        arm64-be
        sh
        sh64
        m86k
        tilegx
        cris
      )
    }.freeze
    ARRAY ||= { kind_of: [String, Array] }
    ARRAY_OF_ABSOLUTE_PATHS ||= {
      kind_of: [String, Array],
      callbacks: {
        'is an absolute path' => lambda do |spec|
          Array(spec).all? { |p| Pathname.new(p).absolute? }
        end
      }
    }.freeze
    ARRAY_OF_SOFT_ABSOLUTE_PATHS |= {
      kind_of: [String, Array],
      callbacks: {
        'has valid arguments' => lambda do |spec|
          Array(spec).all? { |p| Pathname.new(p.gsub(/^\-/, '')).absolute? }
        end
      }
    }.freeze
    ARRAY_OF_UNITS ||= {
      kind_of: [String, Array],
      callbacks: {
        'contains only valid unit names' => lambda do |spec|
           Array(spec).all? { |u| UNIT_TYPES.any? { |t| u.end_with?(t) } }
        end
      }
    }.freeze
    ARRAY_OF_URIS ||= {
      kind_of: Array,
      callbacks: {
        'contains only valid URIs' => lambda do |spec|
          spec.all? { |u| u =~ /\A#{URI::regexp}\z/ }
        end
      }
    }
    BOOLEAN ||= { kind_of: [TrueClass, FalseClass] }.freeze
    CAP ||= {
      kind_of: [String, Array],
      callbacks: {
        'matches capability string' => lambda do |spec|
          Array(spec).all? { |s| s.match(/^(!)?CAP_([A-Z_]+)?[A-Z]+$/) }
        end
      }
    }.freeze
    CONDITIONAL_PATH ||= {
      kind_of: String,
      callbacks: {
        'is empty string or a (piped/negated) absolute path' => lambda do |spec|
          spec.empty? || Pathname.new(spec.gsub(/(\||!)/, '')).absolute?
        end
      }
    }.freeze
    INTEGER ||= { kind_of: Integer }.freeze
    POWER ||= {
      kind_of: String,
      equal_to: %w(
        none
        reboot
        reboot-force
        reboot-immediate
        poweroff
        poweroff-force
        poweroff-immediate
      )
    }.freeze
    SECURITY ||= {
      kind_of: String,
      equal_to: %w( selinux apparmor ima smack audit )
    }.freeze
    STRING ||= { kind_of: String }.freeze
    STRING_OR_ARRAY ||= { kind_of: [String, Array] }.freeze
    STRING_OR_INT ||= { kind_of: [String, Integer] }.freeze
    VIRT ||= {
      kind_of: String,
      equal_to: %w(
        qemu
        kvm
        zvm
        vmware
        microsoft
        oracle
        xen
        bochs
        uml
        openvz
        lxc
        lxc-libvirt
        systemd-nspawn
        docker
        rkt
      )
    }.freeze
  end

  module Unit
    OPTIONS ||= {
      'Unit' => {
        'Description' => Common::STRING,
        'Documentation' => Common::ARRAY_OF_URIS,
        'Requires' => Common::ARRAY_OF_UNITS, 
        'Requisite' => Common::ARRAY_OF_UNITS,
        'Wants' => Common::ARRAY_OF_UNITS,
        'BindsTo' => Common::ARRAY_OF_UNITS,
        'PartOf' => Common::ARRAY_OF_UNITS,
        'Conflicts' => Common::ARRAY_OF_UNITS,
        'Before' => Common::ARRAY_OF_UNITS,
        'After' => Common::ARRAY_OF_UNITS,
        'OnFailure' => Common::ARRAY_OF_UNITS,
        'PropagatesReloadTo' => Common::ARRAY_OF_UNITS,
        'ReloadPropagatedFrom' => Common::ARRAY_OF_UNITS,
        'JoinsNamespaceOf' => Common::ARRAY_OF_UNITS,
        'RequiresMountsFor' => Common::ARRAY_OF_ABSOLUTE_PATHS,
        'OnFailureJobMode' => {
          kind_of: String,
          equal_to: %w(
            fail
            replace
            replace-irreversibly
            isolate
            flush
            ignore-dependencies
            ignore-requirements
          )
        },
        'IgnoreOnIsolate' => Common::BOOLEAN,
        'StopWhenUnneeded' => Common::BOOLEAN,
        'RefuseManualStart' => Common::BOOLEAN,
        'RefuseManualStop' => Common::BOOLEAN,
        'AllowIsolate' => Common::BOOLEAN,
        'DefaultDependencies' => Common::BOOLEAN,
        'JobTimeoutSec' => Common::STRING_OR_INT,
        'JobTimeoutAction' => Common::POWER,
        'JobTimeoutRebootArgument' => Common::STRING,
        'StartLimitIntervalSec' => Common::STRING_OR_INT,
        'StartLimitBurst' => Common::INTEGER,
        'StartLimitAction' => Common::POWER,
        'RebootArgument' => Common::STRING,
        'ConditionArchitecture' => Common::ARCH,
        'ConditionVirtualization' => Common::VIRT,
        'ConditionHost' => Common::STRING,
        'ConditionKernelCommandLine' => Common::STRING,
        'ConditionSecurity' => Common::SECURITY,
        'ConditionCapability' => Common::CAP,
        'ConditionACPower' => Common::BOOLEAN,
        'ConditionNeedsUpdate' => {
          kind_of: String,
          equal_to: %w( /etc /var !/etc !/var )
        },
        'ConditionFirstBoot' => Common::BOOLEAN,
        'ConditionPathExists' => Common::CONDITIONAL_PATH,
        'ConditionPathExistsGlob' => Common::CONDITIONAL_PATH,
        'ConditionPathIsDirectory' => Common::CONDITIONAL_PATH,
        'ConditionPathIsSymbolicLink' => Common::CONDITIONAL_PATH,
        'ConditionPathIsMountPoint' => Common::CONDITIONAL_PATH,
        'ConditionPathIsReadWrite' => Common::CONDITIONAL_PATH,
        'ConditionDirectoryNotEmpty' => Common::CONDITIONAL_PATH,
        'ConditionFileNotEmpty' => Common::CONDITIONAL_PATH,
        'ConditionFileIsExecutable' => Common::CONDITIONAL_PATH,
        'AssertArchitecture' => Common::ARCH,
        'AssertVirtualization' => Common::VIRT,
        'AssertHost' => Common::STRING,
        'AssertKernelCommandLine' => Common::STRING,
        'AssertSecurity' => Common::SECURITY,
        'AssertCapability' => Common::CAP,
        'AssertACPower' => Common::BOOLEAN,
        'AssertNeedsUpdate' => {
          kind_of: String,
          equal_to: %w( /etc /var !/etc !/var )
        },
        'AssertFirstBoot' => Common::BOOLEAN,
        'AssertPathExists' => Common::CONDITIONAL_PATH,
        'AssertPathExistsGlob' => Common::CONDITIONAL_PATH,
        'AssertPathIsDirectory' => Common::CONDITIONAL_PATH,
        'AssertPathIsSymbolicLink' => Common::CONDITIONAL_PATH,
        'AssertPathIsMountPoint' => Common::CONDITIONAL_PATH,
        'AssertPathIsReadWrite' => Common::CONDITIONAL_PATH,
        'AssertDirectoryNotEmpty' => Common::CONDITIONAL_PATH,
        'AssertFileNotEmpty' => Common::CONDITIONAL_PATH,
        'AssertFileIsExecutable' => Common::CONDITIONAL_PATH,
        'SourcePath' => Systmd::Common::ABSOLUTE_PATH
      }
    }.freeze
  end

  module Install
    OPTIONS ||= {
      'Install' => {
        'Alias' => Common::ARRAY_OF_UNITS,
        'WantedBy' => Common::ARRAY_OF_UNITS,
        'RequiredBy' => Common::ARRAY_OF_UNITS,
        'Also' => Common::ARRAY_OF_UNITS,
        'DefaultInstance' => Common::STRING
      }
    }.freeze
  end

  module Exec
    OPTIONS ||= {
      'WorkingDirectory' => {
        kind_of: String,
        callbacks: {
          'is a valid working directory argument' => lambda do |spec|
            spec == '~' || Pathname.new(spec.gsub(/^-/, '')).absolute?
          end
        }
      },
      'RootDirectory' => Common::ABSOLUTE_PATH,
      'User' => Common::STRING_OR_INT,
      'Group' => Common::STRING_OR_INT,
      'SupplementaryGroups' => Common::ARRAY,
      'Nice' => { kind_of: Integer, equal_to: -20.upto(19).to_a },
      'OOMScoreAdjust' => { kind_of: Integer, equal_to: -1000.upto(1000).to_a },
      'IOSchedulingClass' => {
        kind_of: [Integer, String],
        equal_to: [0, 1, 2, 3, 'none', 'realtime', 'best-effort', 'idle']
      },
      'IOSchedulingPriority' => { kind_of: Integer, equal_to: 0.upto(7).to_a },
      'CPUSchedulingPolicy' => {
        kind_of: String,
        equal_to: %w( other batch idle fifo rr )
      },
      'CPUSchedulingPriority' => {
        kind_of: Integer,
        equal_to: 0.upto(99).to_a
      },
      'CPUSchedulingResetOnFork' => Common::BOOLEAN,
      'CPUAffinity' => { kind_of: [String, Integer, Array] },
      'UMask' => Common::STRING,
      'Environment' => { kind_of: [String, Array, Hash] },
      'EnvironmentFile' => Common::SOFT_ABSOLUTE_PATH,
      'PassEnvironment' => { kind_of: [String, Array] },
      'StandardInput' => {
        kind_of: String,
        equal_to: %w( null tty tty-force tty-fail socket )
      },
      'StandardOutput' => {
        kind_of: String,
        equal_to: %w(
          inherit
          null
          tty
          journal
          syslog
          kmsg
          journal+console
          syslog+console
          kmsg+console
          socket
        )
      },
      'StandardError' => {
        kind_of: String,
        equal_to: %w(
          inherit
          null
          tty
          journal
          syslog
          kmsg
          journal+console
          syslog+console
          kmsg+console
          socket
        )
      },
      'TTYPath' => Common::ABSOLUTE_PATH,
      'TTYReset' => Common::BOOLEAN,
      'TTYVHangup' => Common::BOOLEAN,
      'TTYVTDisallocate' => Common::BOOLEAN,
      'SyslogIdentifier' => Common::STRING,
      'SyslogFacility' => {
        kind_of: String,
        equal_to: %w(
          kern
          user
          mail
          daemon
          auth
          syslog
          lpr
          news
          uucp
          cron
          authpriv
          ftp
          local0
          local1
          local2
          local3
          local4
          local5
          local6
          local7
        )
      },
      'SyslogLevel' => {
        kind_of: String,
        equal_to: %w( emerg alert crit err warning notice info debug )
      },
      'SyslogLevelPrefix' => Common::BOOLEAN,
      'TimerSlackNSec' => Common::STRING_OR_INT,
      'LimitCPU' => Common::STRING_OR_INT,
      'LimitFSIZE' => Common::STRING_OR_INT,
      'LimitDATA' => Common::STRING_OR_INT,
      'LimitSTACK' => Common::STRING_OR_INT,
      'LimitCORE' => Common::STRING_OR_INT,
      'LimitRSS' => Common::STRING_OR_INT,
      'LimitNOFILE' => Common::STRING_OR_INT,
      'LimitAS' => Common::STRING_OR_INT,
      'LimitNPROC' => Common::STRING_OR_INT,
      'LimitMEMLOCK' => Common::STRING_OR_INT,
      'LimitLOCKS' => Common::STRING_OR_INT,
      'LimitSIGPENDING' => Common::STRING_OR_INT,
      'LimitMSGQUEUE' => Common::STRING_OR_INT,
      'LimitNICE' => Common::STRING_OR_INT,
      'LimitRTPRIO' => Common::STRING_OR_INT,
      'LimitRTTIME' => Common::STRING_OR_INT,
      'PAMName' => Common::STRING,
      'CapabilityBoundingSet' => Common::CAP,
      'AmbientCapabilities' => Common::CAP,
      'SecureBits' => {
        kind_of: [String, Array],
        callbacks: {
          'contains only supported values' => lambda do |spec|
            Array(spec).all? do |s|
              s.empty? || %w(
                keep-caps
                keep-caps-locked
                no-setuid-fixup
                no-setuid-fixup-locked
                noroot
                noroot-locked
              ).include?(s)
            end
          end
        }
      },
      'ReadWriteDirectories' => Common::ARRAY_OF_ABSOLUTE_PATHS,
      'ReadOnlyDirectories' => Common::ARRAY_OF_SOFT_ABSOLUTE_PATHS,
      'InaccessibleDirectories' => Common::ARRAY_OF_SOFT_ABSOLUTE_PATHS,
      'PrivateTmp' => Common::BOOLEAN,
      'PrivateDevices' => Common::BOOLEAN,
      'PrivateNetwork' => Common::BOOLEAN,
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
      'UtmpIdentifier' => Common::STRING,
      'UtmpMode' => {
        kind_of: String,
        equal_to: %w( init login user )
      },
      'SELinuxContext' => Common::STRING,
      'AppArmorProfile' => Common::STRING,
      'SmackProcessLabel' => Common::STRING,
      'IgnoreSIGPIPE' => Common::BOOLEAN,
      'NoNewPrivileges' => Common::BOOLEAN,
      'SystemCallFilter' => Common::STRING_OR_ARRAY,
      'SystemCallErrorNumber' => Common::STRING,
      'SystemCallArchitectures' => Common::ARCH,
      'RestrictAddressFamilies' => Common::STRING_OR_ARRAY,
      'Personality' => Common::ARCH,
      'RuntimeDirectory' => {
        kind_of: [String, Array],
        callbacks: {
          'only simple, relative paths' => lambda do |spec|
            Array(spec).all? { |p| !p.include?('/') }
          end
        }
      },
      'RuntimeDirectoryMode' => Common::STRING,
    }.freeze
  end

  module ResourceControl

  end

  module Kill

  end

  module Automount
    OPTIONS ||= {
      'Automount' => {
        'Where' => {
          kind_of: String,
          required: true,
          callbacks: {
            'is an absolute path' => -> (spec) { Pathname.new(spec).absolute? }
          }
        },
        'DirectoryMode' => Common::STRING,
        'TimeoutIdleSec' => Common::STRING_OR_INT,
      }
    }.freeze
  end

  module Device
    UDEV_PROPERTIES ||= %w(
      SYSTEMD_WANTS
      SYSTEMD_USER_WANTS
      SYSTEMD_ALIAS
      SYSTEMD_READY
      ID_MODEL_FROM_DATABASE
      ID_MODEL
    )
  end

  module Mount
    OPTIONS ||= {
      'Mount' => {
        
      }
    }.freeze
  end

  module Path

  end

  module Scope

  end

  module Service

  end

  module Slice

  end

  module Socket

  end

  module Swap

  end

  module Target

  end

  module Timer

  end
end
