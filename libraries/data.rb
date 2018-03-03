#
# Cookbook Name:: systemd
# Library:: SystemdCookbook
#
# Copyright 2016 The Authors
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

module SystemdCookbook
  UNITS ||= %w(
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
  ).freeze

  BUS_ONLY_UNITS ||= %w(scope).freeze

  DAEMONS ||= %w(
    journald
    logind
    resolved
    system
    timesyncd
    user
  ).freeze

  UTILS ||= %w(
    binfmt
    bootchart
    coredump
    modules
    sleep
    sysctl
    sysuser
    tmpfile
  ).freeze

  NETS ||= %w(
    link
    netdev
    network
  ).freeze

  module Common
    ABSOLUTE_PATH ||= {
      kind_of: String,
      callbacks: {
        'is an absolute path' => ->(spec) { Pathname.new(spec).absolute? },
      },
    }.freeze
    SOFT_ABSOLUTE_PATH ||= {
      kind_of: String,
      callbacks: {
        'is an absolute path' => lambda do |spec|
          Pathname.new(spec.gsub(/^\-/, '')).absolute?
        end,
      },
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
      ),
    }.freeze
    ARRAY ||= { kind_of: [String, Array] }.freeze
    ARRAY_OF_ABSOLUTE_PATHS ||= {
      kind_of: [String, Array],
      callbacks: {
        'is an absolute path' => lambda do |spec|
          Array(spec).all? { |p| Pathname.new(p).absolute? }
        end,
      },
    }.freeze
    ARRAY_OF_SOFT_ABSOLUTE_PATHS ||= {
      kind_of: [String, Array],
      callbacks: {
        'has valid arguments' => lambda do |spec|
          Array(spec).all? { |p| Pathname.new(p.gsub(/^\-/, '')).absolute? }
        end,
      },
    }.freeze
    ARRAY_OF_UNITS ||= {
      kind_of: [String, Array],
      callbacks: {
        'contains only valid unit names' => lambda do |spec|
          Array(spec).all? { |u| UNITS.any? { |t| u.end_with?(t) } }
        end,
      },
    }.freeze
    ARRAY_OF_URIS ||= {
      kind_of: [String, Array],
      callbacks: {
        'contains only valid URIs' => lambda do |spec|
          Array(spec).all? { |u| u =~ /\A#{URI.regexp}\z/ }
        end,
      },
    }.freeze
    BOOLEAN ||= { kind_of: [TrueClass, FalseClass] }.freeze
    CAP ||= {
      kind_of: [String, Array],
      callbacks: {
        'matches capability string' => lambda do |spec|
          Array(spec).all? { |s| s.match(/^(!)?CAP_([A-Z_]+)?[A-Z]+$/) }
        end,
      },
    }.freeze
    CGROUPS ||= {
      kind_of: String,
      equal_to: %w( cpu cpuacct io blkio memory devices pids ),
    }.freeze
    CONDITIONAL_PATH ||= {
      kind_of: String,
      callbacks: {
        'is empty string or a (piped/negated) absolute path' => lambda do |spec|
          spec.empty? || Pathname.new(spec.gsub(/(\||!)/, '')).absolute?
        end,
      },
    }.freeze
    INTEGER ||= { kind_of: Integer }.freeze
    LOGLEVEL ||= {
      kind_of: [String, Integer],
      equal_to: %w(
        emerg
        alert
        crit
        err
        warning
        notice
        info
        debug
      ).concat(0.upto(7).to_a),
    }.freeze
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
      ),
    }.freeze
    SECURITY ||= {
      kind_of: String,
      equal_to: %w(selinux apparmor ima smack audit),
    }.freeze
    SESSION_ACTIONS ||= {
      kind_of: String,
      equal_to: %w(
        ignore
        poweroff
        reboot
        halt
        kexec
        suspend
        hibernate
        hybrid-sleep
        lock
      ),
    }.freeze
    STDALL ||= {
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
      ),
    }.freeze
    STRING ||= { kind_of: String }.freeze
    STRING_OR_ARRAY ||= { kind_of: [String, Array] }.freeze
    STRING_OR_INT ||= { kind_of: [String, Integer] }.freeze
    UNIT ||= {
      kind_of: String,
      callbacks: {
        'is a unit name' => lambda do |spec|
          UNITS.any? { |t| spec.end_with?(t) }
        end,
      },
    }.freeze
    VIRT ||= {
      kind_of: [String, TrueClass, FalseClass],
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
      ).concat([true, false]),
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
          ),
        },
        'IgnoreOnIsolate' => Common::BOOLEAN,
        'StopWhenUnneeded' => Common::BOOLEAN,
        'RefuseManualStart' => Common::BOOLEAN,
        'RefuseManualStop' => Common::BOOLEAN,
        'AllowIsolate' => Common::BOOLEAN,
        'DefaultDependencies' => Common::BOOLEAN,
        'CollectMode' => {
          kind_of: String,
          equal_to: %w( inactive inactive-or-failed ),
        },
        'JobTimeoutSec' => Common::STRING_OR_INT,
        'JobRunningTimeoutSec' => Common::STRING_OR_INT,
        'JobTimeoutAction' => Common::POWER,
        'JobTimeoutRebootArgument' => Common::STRING,
        'StartLimitInterval' => Common::STRING_OR_INT,
        'StartLimitIntervalSec' => Common::STRING_OR_INT,
        'StartLimitBurst' => Common::INTEGER,
        'StartLimitAction' => Common::POWER,
        'FailureAction' => Common::POWER,
        'SuccessAction' => Common::POWER,
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
          equal_to: %w(/etc /var !/etc !/var),
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
        'ConditionUser' => Common::STRING_OR_INT,
        'ConditionGroup' => Common::STRING_OR_INT,
        'ConditionControlGroupController' => Common::CGROUPS,
        'AssertArchitecture' => Common::ARCH,
        'AssertVirtualization' => Common::VIRT,
        'AssertHost' => Common::STRING,
        'AssertKernelCommandLine' => Common::STRING,
        'AssertSecurity' => Common::SECURITY,
        'AssertCapability' => Common::CAP,
        'AssertACPower' => Common::BOOLEAN,
        'AssertNeedsUpdate' => {
          kind_of: String,
          equal_to: %w(/etc /var !/etc !/var),
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
        'AssertUser' => Common::STRING_OR_INT,
        'AssertGroup' => Common::STRING_OR_INT,
        'AssertControlGroupController' => Common::CGROUPS,
        'SourcePath' => Common::ABSOLUTE_PATH,
      },
    }.freeze
  end

  module Install
    OPTIONS ||= {
      'Install' => {
        'Alias' => Common::ARRAY_OF_UNITS,
        'WantedBy' => Common::ARRAY_OF_UNITS,
        'RequiredBy' => Common::ARRAY_OF_UNITS,
        'Also' => Common::ARRAY_OF_UNITS,
        'DefaultInstance' => Common::STRING,
      },
    }.freeze
  end

  module Exec
    OPTIONS ||= {
      'WorkingDirectory' => Common::STRING,
      'RootDirectory' => Common::ABSOLUTE_PATH,
      'RootImage' => Common::ABSOLUTE_PATH,
      'MountAPIVFS' => Common::BOOLEAN,
      'BindPaths' => Common::STRING_OR_ARRAY,
      'BindReadOnlyPaths' => Common::STRING_OR_ARRAY,
      'User' => Common::STRING_OR_INT,
      'Group' => Common::STRING_OR_INT,
      'DynamicUser' => Common::BOOLEAN,
      'SupplementaryGroups' => Common::ARRAY,
      'PAMName' => Common::STRING,
      'Nice' => { kind_of: Integer, equal_to: -20.upto(19).to_a },
      'IOSchedulingClass' => {
        kind_of: [Integer, String],
        equal_to: [0, 1, 2, 3, 'none', 'realtime', 'best-effort', 'idle'],
      },
      'IOSchedulingPriority' => { kind_of: Integer, equal_to: 0.upto(7).to_a },
      'CPUSchedulingPolicy' => {
        kind_of: String,
        equal_to: %w(other batch idle fifo rr),
      },
      'CPUSchedulingPriority' => {
        kind_of: Integer,
        equal_to: 0.upto(99).to_a,
      },
      'CPUSchedulingResetOnFork' => Common::BOOLEAN,
      'CPUAffinity' => { kind_of: [String, Integer, Array] },
      'UMask' => Common::STRING,
      'KeyringMode' => { kind_of: String, equal_to: %w( inherit private shared ) },
      'OOMScoreAdjust' => { kind_of: Integer, equal_to: (-1000..1000).to_a },
      'Environment' => { kind_of: [String, Array, Hash] },
      'EnvironmentFile' => Common::SOFT_ABSOLUTE_PATH,
      'PassEnvironment' => Common::STRING_OR_ARRAY,
      'UnsetEnvironment' => Common::STRING_OR_ARRAY,
      'StandardInput' => {
        kind_of: String,
        equal_to: %w(null tty tty-force tty-fail socket),
      },
      'StandardOutput' => Common::STDALL,
      'StandardError' => Common::STDALL,
      'StandardInputText' => Common::STRING,
      'StandardInputData' => Common::STRING,
      'LogLevelMax' => {
        kind_of: String,
        equal_to: %w(
          emerg
          alert
          crit
          err
          warning
          notice
          info
          debug
        ),
      },
      'LogExtraFields' => { kind_of: [String, Array, Hash] },
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
        ),
      },
      'SyslogLevel' => {
        kind_of: String,
        equal_to: %w(emerg alert crit err warning notice info debug),
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
      'CapabilityBoundingSet' => Common::CAP,
      'AmbientCapabilities' => Common::CAP,
      'NoNewPrivileges' => Common::BOOLEAN,
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
          end,
        },
      },
      'ReadWriteDirectories' => Common::ARRAY_OF_ABSOLUTE_PATHS,
      'ReadOnlyDirectories' => Common::ARRAY_OF_SOFT_ABSOLUTE_PATHS,
      'InaccessibleDirectories' => Common::ARRAY_OF_SOFT_ABSOLUTE_PATHS,
      'ReadWritePaths' => Common::ARRAY_OF_ABSOLUTE_PATHS,
      'ReadOnlyPaths' => Common::ARRAY_OF_SOFT_ABSOLUTE_PATHS,
      'InaccessiblePaths' => Common::ARRAY_OF_SOFT_ABSOLUTE_PATHS,
      'PrivateTmp' => Common::BOOLEAN,
      'PrivateDevices' => Common::BOOLEAN,
      'PrivateNetwork' => Common::BOOLEAN,
      'PrivateUsers' => Common::BOOLEAN,
      'ProtectKernelTunables' => Common::BOOLEAN,
      'ProtectKernelModules' => Common::BOOLEAN,
      'ProtectControlGroups' => Common::BOOLEAN,
      'ProtectSystem' => {
        kind_of: [TrueClass, FalseClass, String],
        equal_to: [true, false, 'full'],
      },
      'ProtectHome' => {
        kind_of: [TrueClass, FalseClass, String],
        equal_to: [true, false, 'read-only'],
      },
      'MountFlags' => {
        kind_of: String,
        equal_to: %w(shared slave private),
      },
      'UtmpIdentifier' => Common::STRING,
      'UtmpMode' => {
        kind_of: String,
        equal_to: %w(init login user),
      },
      'SELinuxContext' => Common::STRING,
      'AppArmorProfile' => Common::STRING,
      'SmackProcessLabel' => Common::STRING,
      'IgnoreSIGPIPE' => Common::BOOLEAN,
      'SystemCallFilter' => Common::STRING_OR_ARRAY,
      'SystemCallErrorNumber' => Common::STRING,
      'SystemCallArchitectures' => Common::ARCH,
      'RestrictAddressFamilies' => Common::STRING_OR_ARRAY,
      'RestrictNamespaces' => { kind_of: [String, TrueClass, FalseClass] },
      'LockPersonality' => Common::BOOLEAN,
      'MemoryDenyWriteExecute' => Common::BOOLEAN,
      'RestrictRealtime' => Common::BOOLEAN,
      'RemoveIPC' => Common::BOOLEAN,
      'Personality' => Common::ARCH,
      'RuntimeDirectory' => Common::STRING_OR_ARRAY,
      'StateDirectory' => Common::STRING_OR_ARRAY,
      'LogsDirectory' => Common::STRING_OR_ARRAY,
      'ConfigurationDirectory' => Common::STRING_OR_ARRAY,
      'RuntimeDirectoryMode' => Common::STRING,
      'StateDirectoryMode' => Common::STRING,
      'CacheDirectoryMode' => Common::STRING,
      'LogsDirectoryMode' => Common::STRING,
      'ConfigurationDirectoryMode' => Common::STRING,
      'RuntimeDirectoryPreserve' => {
        kind_of: [String, TrueClass, FalseClass],
        equal_to: [true, false, 'restart'],
      },
    }.freeze
  end

  module Kill
    OPTIONS ||= {
      'KillMode' => {
        kind_of: String,
        equal_to: %w(control-group process mixed none),
      },
      'KillSignal' => Common::STRING_OR_INT,
      'SendSIGHUP' => Common::BOOLEAN,
      'SendSIGKILL' => Common::BOOLEAN,
    }.freeze
  end

  module ResourceControl
    OPTIONS ||= {
      'CPUAccounting' => Common::BOOLEAN,
      'CPUWeight' => { kind_of: Integer, equal_to: (1..10000).to_a },
      'StartupCPUWeight' => { kind_of: Integer, equal_to: (1..10000).to_a },
      'CPUShares' => {
        kind_of: Integer,
        equal_to: 2.upto(262_144).to_a,
      },
      'StartupCPUShares' => {
        kind_of: Integer,
        equal_to: 2.upto(262_144).to_a,
      },
      'CPUQuota' => {
        kind_of: String,
        callbacks: {
          'is a percentage' => lambda do |spec|
            spec.end_with?('%') && spec.gsub(/%$/, '').match(/^\d+$/)
          end,
        },
      },
      'MemoryAccounting' => Common::BOOLEAN,
      'MemoryLow' => Common::STRING_OR_INT,
      'MemoryHigh' => Common::STRING_OR_INT,
      'MemoryMax' => Common::STRING_OR_INT,
      'MemorySwapMax' => Common::STRING_OR_INT,
      'MemoryLimit' => Common::STRING_OR_INT,
      'TasksAccounting' => Common::BOOLEAN,
      'TasksMax' => {
        kind_of: [String, Integer],
        callbacks: {
          'is an integer or "infinity"' => lambda do |spec|
            spec.is_a?(Integer) || spec == 'infinity'
          end,
        },
      },
      'IOAccounting' => Common::BOOLEAN,
      'IOWeight' => {
        kind_of: Integer,
        equal_to: 1.upto(10_000).to_a,
      },
      'StartupIOWeight' => {
        kind_of: Integer,
        equal_to: 1.upto(10_000).to_a,
      },
      'IODeviceWeight' => {
        kind_of: String,
        callbacks: {
          'is a valid argument' => lambda do |spec|
            args = spec.split(' ')
            args.length == 2 &&
              Pathname.new(args[0]).absolute? &&
              1.upto(10_000).include?(args[1].to_i)
          end,
        },
      },
      'IOReadBandwidthMax' => Common::STRING_OR_INT,
      'IOWriteBandwidthMax' => Common::STRING_OR_INT,
      'IOReadIOPSMax' => {
        kind_of: String,
        callbacks: {
          'is a valid argument' => lambda do |spec|
            args = spec.split(' ')
            args.length == 2 &&
              Pathname.new(args[0]).absolute?
          end,
        },
      },
      'IOWriteIOPSMax' => {
        kind_of: String,
        callbacks: {
          'is a valid argument' => lambda do |spec|
            args = spec.split(' ')
            args.length == 2 &&
              Pathname.new(args[0]).absolute?
          end,
        },
      },
      'IPAccounting' => Common::BOOLEAN,
      'IPAddressAllow' => Common::STRING_OR_ARRAY,
      'IPAddressDeny' => Common::STRING_OR_ARRAY,
      'BlockIOAccounting' => Common::BOOLEAN,
      'BlockIOWeight' => {
        kind_of: Integer,
        equal_to: 10.upto(1_000).to_a,
      },
      'StartupBlockIOWeight' => {
        kind_of: Integer,
        equal_to: 10.upto(1_000).to_a,
      },
      'BlockIODeviceWeight' => {
        kind_of: String,
        callbacks: {
          'is a valid argument' => lambda do |spec|
            args = spec.split(' ')
            args.length == 2 &&
              Pathname.new(args[0]).absolute? &&
              10.upto(1_000).include?(args[1].to_i)
          end,
        },
      },
      'BlockIOReadBandwidth' => {
        kind_of: String,
        callbacks: {
          'is a valid argument' => lambda do |spec|
            args = spec.split(' ')
            args.length == 2 &&
              Pathname.new(args[0]).absolute?
          end,
        },
      },
      'BlockIOWriteBandwidth' => {
        kind_of: String,
        callbacks: {
          'is a valid argument' => lambda do |spec|
            args = spec.split(' ')
            args.length == 2 &&
              Pathname.new(args[0]).absolute?
          end,
        },
      },
      'DeviceAllow' => {
        kind_of: String,
        callbacks: {
          'is a valid argument' => lambda do |spec|
            args = spec.split(' ')
            args.length == 2 &&
              Pathname.new(args[0]).absolute? &&
              %w(r w m).include?(args[1])
          end,
        },
      },
      'DevicePolicy' => { kind_of: String, equal_to: %w(strict auto closed) },
      'Slice' => {
        kind_of: String,
        callbacks: {
          'is a slice' => ->(spec) { spec.end_with?('.slice') },
        },
      },
      'Delegate' => Common::BOOLEAN,
    }.freeze
  end

  module Automount
    OPTIONS ||= {
      'Automount' => {
        'Where' => {
          kind_of: String,
          callbacks: {
            'is an absolute path' => ->(spec) { Pathname.new(spec).absolute? },
          },
        },
        'DirectoryMode' => Common::STRING,
        'TimeoutIdleSec' => Common::STRING_OR_INT,
      },
    }.merge(Unit::OPTIONS)
                .merge(Install::OPTIONS)
                .freeze
  end

  module Device
    UDEV_PROPERTIES ||= %w(
      SYSTEMD_WANTS
      SYSTEMD_USER_WANTS
      SYSTEMD_ALIAS
      SYSTEMD_READY
      ID_MODEL_FROM_DATABASE
      ID_MODEL
    ).freeze

    OPTIONS ||= {}.merge(Unit::OPTIONS)
                  .merge(Install::OPTIONS)
  end

  module Mount
    OPTIONS ||= {
      'Mount' => {
        'What' => {
          kind_of: String,
        },
        'Where' => {
          kind_of: String,
          callbacks: {
            'absolute path' => ->(s) { Pathname.new(s).absolute? },
          },
        },
        'Type' => Common::STRING,
        'Options' => Common::STRING,
        'SloppyOptions' => Common::BOOLEAN,
        'LazyUnmount' => Common::BOOLEAN,
        'ForceUnmount' => Common::BOOLEAN,
        'DirectoryMode' => Common::STRING,
        'TimeoutSec' => Common::STRING_OR_INT,
      }.merge(Exec::OPTIONS)
                .merge(Kill::OPTIONS)
                .merge(ResourceControl::OPTIONS),
    }.merge(Unit::OPTIONS)
                .merge(Install::OPTIONS)
                .freeze
  end

  module Path
    OPTIONS ||= {
      'Path' => {
        'PathExists' => Common::ABSOLUTE_PATH,
        'PathExistsGlob' => Common::ABSOLUTE_PATH,
        'PathChanged' => Common::ABSOLUTE_PATH,
        'PathModified' => Common::ABSOLUTE_PATH,
        'DirectoryNotEmpty' => Common::ABSOLUTE_PATH,
        'Unit' => Common::UNIT,
        'MakeDirectory' => Common::BOOLEAN,
        'DirectoryMode' => Common::STRING,
      },
    }.merge(Unit::OPTIONS)
                .merge(Install::OPTIONS)
                .freeze
  end

  module Scope
    OPTIONS ||= {
      'Scope' => {}.merge(ResourceControl::OPTIONS),
    }.merge(Unit::OPTIONS)
                .freeze
  end

  module Service
    OPTIONS ||= {
      'Service' => {
        'Type' => {
          kind_of: String,
          equal_to: %w(simple forking oneshot dbus notify idle),
        },
        'RemainAfterExit' => Common::BOOLEAN,
        'GuessMainPID' => Common::BOOLEAN,
        'PIDFile' => Common::ABSOLUTE_PATH,
        'BusName' => Common::STRING,
        'ExecStart' => Common::STRING,
        'ExecStartPre' => Common::STRING,
        'ExecStartPost' => Common::STRING,
        'ExecReload' => Common::STRING,
        'ExecStop' => Common::STRING,
        'ExecStopPost' => Common::STRING,
        'RestartSec' => Common::STRING_OR_INT,
        'TimeoutStartSec' => Common::STRING_OR_INT,
        'TimeoutStopSec' => Common::STRING_OR_INT,
        'TimeoutSec' => Common::STRING_OR_INT,
        'RuntimeMaxSec' => Common::STRING_OR_INT,
        'WatchdogSec' => Common::STRING_OR_INT,
        'Restart' => {
          kind_of: String,
          equal_to: %w(
            no
            on-success
            on-failure
            on-abnormal
            on-watchdog
            on-abort
            always
          ),
        },
        'SuccessExitStatus' => { kind_of: [String, Array, Integer] },
        'RestartPreventExitStatus' => { kind_of: [String, Array, Integer] },
        'RestartForceExitStatus' => { kind_of: [String, Array, Integer] },
        'PermissionsStartOnly' => Common::BOOLEAN,
        'RootDirectoryStartOnly' => Common::BOOLEAN,
        'NonBlocking' => Common::BOOLEAN,
        'NotifyAccess' => { kind_of: String, equal_to: %w(none main exec all) },
        'Sockets' => Common::ARRAY_OF_UNITS,
        'FailureAction' => Common::POWER,
        'FileDescriptorStoreMax' => Common::INTEGER,
        'USBFunctionDescriptors' => Common::STRING,
        'USBFunctionStrings' => Common::STRING,
      }.merge(Exec::OPTIONS)
                .merge(Kill::OPTIONS)
                .merge(ResourceControl::OPTIONS),
    }.merge(Unit::OPTIONS)
                .merge(Install::OPTIONS)
                .freeze
  end

  module Slice
    OPTIONS ||= {
      'Slice' => {}.merge(ResourceControl::OPTIONS),
    }.merge(Unit::OPTIONS)
                .merge(Install::OPTIONS)
                .freeze
  end

  module Socket
    OPTIONS ||= {
      'Socket' => {
        'ListenStream' => Common::STRING_OR_INT,
        'ListenDatagram' => Common::STRING_OR_INT,
        'ListenSequentialPacket' => Common::STRING_OR_INT,
        'ListenFIFO' => Common::ABSOLUTE_PATH,
        'ListenSpecial' => Common::ABSOLUTE_PATH,
        'ListenNetlink' => Common::STRING,
        'ListenMessageQueue' => Common::ABSOLUTE_PATH,
        'ListenUSBFunction' => Common::STRING,
        'SocketProtocol' => { kind_of: String, equal_to: %w(udplite sctp) },
        'BindIPv6Only' => {
          kind_of: String,
          equal_to: %w(default both ipv6-only),
        },
        'Backlog' => Common::INTEGER,
        'BindToDevice' => Common::STRING,
        'SocketUser' => Common::STRING,
        'SocketGroup' => Common::STRING,
        'SocketMode' => Common::STRING,
        'DirectoryMode' => Common::STRING,
        'Accept' => Common::BOOLEAN,
        'Writable' => Common::BOOLEAN,
        'MaxConnections' => Common::INTEGER,
        'KeepAlive' => Common::BOOLEAN,
        'KeepAliveTimeSec' => Common::STRING_OR_INT,
        'KeepAliveIntervalSec' => Common::STRING_OR_INT,
        'KeepAliveProbes' => Common::INTEGER,
        'NoDelay' => Common::BOOLEAN,
        'Priority' => Common::INTEGER,
        'DeferAcceptSec' => Common::STRING_OR_INT,
        'ReceiveBuffer' => Common::STRING_OR_INT,
        'SendBuffer' => Common::STRING_OR_INT,
        'IPTOS' => {
          kind_of: [String, Integer],
          callbacks: {
            'is a valid arg' => lambda do |spec|
              %w(low-delay throughput reliability low-cost).include?(spec) ||
                spec.is_a?(Integer)
            end,
          },
        },
        'IPTTL' => Common::INTEGER,
        'Mark' => Common::INTEGER,
        'ReusePort' => Common::BOOLEAN,
        'SmackLabel' => Common::STRING,
        'SmackLabelIPIn' => Common::STRING,
        'SmackLabelIPOut' => Common::STRING,
        'SELinuxContextFromNet' => Common::BOOLEAN,
        'PipeSize' => Common::STRING_OR_INT,
        'MessageQueueMaxMessages' => Common::INTEGER,
        'MessageQueueMessageSize' => Common::STRING_OR_INT,
        'FreeBind' => Common::BOOLEAN,
        'Transparent' => Common::BOOLEAN,
        'Broadcast' => Common::BOOLEAN,
        'PassCredentials' => Common::BOOLEAN,
        'PassSecurity' => Common::BOOLEAN,
        'TCPCongestion' => Common::STRING,
        'ExecStartPre' => Common::STRING,
        'ExecStartPost' => Common::STRING,
        'ExecStopPre' => Common::STRING,
        'ExecStopPost' => Common::STRING,
        'TimeoutSec' => Common::STRING_OR_INT,
        'Service' => {
          kind_of: String,
          callbacks: {
            'is a service' => ->(s) { s.end_with?('.service') },
          },
        },
        'RemoveOnStop' => Common::BOOLEAN,
        'Symlinks' => Common::ARRAY_OF_ABSOLUTE_PATHS,
        'FileDescriptorName' => Common::STRING,
        'TriggerLimitIntervalSec' => Common::STRING_OR_INT,
        'TriggerLimitBurst' => Common::INTEGER,
      }.merge(Exec::OPTIONS)
                .merge(Kill::OPTIONS)
                .merge(ResourceControl::OPTIONS),
    }.merge(Unit::OPTIONS)
                .merge(Install::OPTIONS)
                .freeze
  end

  module Swap
    OPTIONS ||= {
      'Swap' => {
        'What' => {
          kind_of: String,
          callbacks: {
            'is an absolute path' => ->(s) { Pathname.new(s).absolute? },
          },
        },
        'Priority' => Common::INTEGER,
        'Options' => Common::STRING,
        'TimeoutSec' => Common::STRING_OR_INT,
      }.merge(Exec::OPTIONS)
                .merge(Kill::OPTIONS)
                .merge(ResourceControl::OPTIONS),
    }.merge(Unit::OPTIONS)
                .merge(Install::OPTIONS)
                .freeze
  end

  module Target
    OPTIONS ||= {}.merge(Unit::OPTIONS)
                  .merge(Install::OPTIONS)
                  .freeze
  end

  module Timer
    OPTIONS ||= {
      'Timer' => {
        'OnActiveSec' => Common::STRING_OR_INT,
        'OnBootSec' => Common::STRING_OR_INT,
        'OnStartupSec' => Common::STRING_OR_INT,
        'OnUnitActiveSec' => Common::STRING_OR_INT,
        'OnUnitInactiveSec' => Common::STRING_OR_INT,
        'OnCalendar' => Common::STRING,
        'AccuracySec' => Common::STRING_OR_INT,
        'RandomizedDelaySec' => Common::STRING_OR_INT,
        'Unit' => Common::UNIT,
        'Persistent' => Common::BOOLEAN,
        'WakeSystem' => Common::BOOLEAN,
        'RemainAfterElapse' => Common::BOOLEAN,
      },
    }.merge(Unit::OPTIONS)
                .merge(Install::OPTIONS)
                .freeze
  end

  module Bootchart
    OPTIONS ||= {
      'Bootchart' => {
        'Samples' => Common::INTEGER,
        'Frequency' => { kind_of: Numeric },
        'Relative' => Common::BOOLEAN,
        'Filter' => Common::BOOLEAN,
        'Output' => Common::ABSOLUTE_PATH,
        'Init' => Common::ABSOLUTE_PATH,
        'PlotMemoryUsage' => Common::BOOLEAN,
        'PlotEntropyGraph' => Common::BOOLEAN,
        'ScaleX' => Common::INTEGER,
        'ScaleY' => Common::INTEGER,
        'ControlGroup' => Common::BOOLEAN,
      },
    }.freeze
  end

  module Coredump
    OPTIONS ||= {
      'Coredump' => {
        'Storage' => {
          kind_of: String,
          equal_to: %w(none external journal both),
        },
        'Compress' => Common::BOOLEAN,
        'ProcessSizeMax' => Common::INTEGER,
        'ExternalSizeMax' => Common::INTEGER,
        'JournalSizeMax' => Common::INTEGER,
        'MaxUse' => Common::STRING_OR_INT,
        'KeepFree' => Common::STRING_OR_INT,
      },
    }.freeze
  end

  module Journald
    OPTIONS ||= {
      'Journal' => {
        'Storage' => {
          kind_of: String,
          equal_to: %w(volatile persistent auto none),
        },
        'Compress' => Common::BOOLEAN,
        'Seal' => Common::BOOLEAN,
        'SplitMode' => { kind_of: String, equal_to: %w(uid login none) },
        'RateLimitInterval' => Common::STRING_OR_INT,
        'RateLimitIntervalSec' => Common::STRING_OR_INT,
        'RateLimitBurst' => Common::INTEGER,
        'SystemMaxUse' => Common::STRING,
        'SystemKeepFree' => Common::STRING,
        'SystemMaxFileSize' => Common::STRING,
        'SystemMaxFiles' => Common::INTEGER,
        'RuntimeMaxUse' => Common::STRING,
        'RuntimeKeepFree' => Common::STRING,
        'RuntimeMaxFileSize' => Common::STRING,
        'RuntimeMaxFiles' => Common::INTEGER,
        'MaxFileSec' => Common::STRING_OR_INT,
        'MaxRetentionSec' => Common::STRING_OR_INT,
        'SyncIntervalSec' => Common::STRING_OR_INT,
        'ForwardToSyslog' => Common::BOOLEAN,
        'ForwardToKMsg' => Common::BOOLEAN,
        'ForwardToConsole' => Common::BOOLEAN,
        'ForwardToWall' => Common::BOOLEAN,
        'MaxLevelStore' => Common::LOGLEVEL,
        'MaxLevelSyslog' => Common::LOGLEVEL,
        'MaxLevelKMsg' => Common::LOGLEVEL,
        'MaxLevelConsole' => Common::LOGLEVEL,
        'MaxLevelWall' => Common::LOGLEVEL,
        'TTYPath' => Common::ABSOLUTE_PATH,
        'LineMax' => Common::STRING_OR_INT,
      },
    }.freeze
  end

  module Logind
    OPTIONS ||= {
      'Login' => {
        'NAutoVTs' => {
          kind_of: Integer,
          callbacks: { 'is positive' => ->(s) { s > 0 } },
        },
        'ReserveVT' => {
          kind_of: Integer,
          callbacks: { 'is positive' => ->(s) { s > 0 } },
        },
        'KillUserProcesses' => Common::BOOLEAN,
        'KillOnlyUsers' => Common::STRING_OR_ARRAY,
        'KillExcludeUsers' => Common::STRING_OR_ARRAY,
        'IdleAction' => Common::SESSION_ACTIONS,
        'IdleActionSec' => Common::STRING_OR_INT,
        'InhibitDelayMaxSec' => Common::STRING_OR_INT,
        'HandlePowerKey' => Common::SESSION_ACTIONS,
        'HandleSuspendKey' => Common::SESSION_ACTIONS,
        'HandleHibernateKey' => Common::SESSION_ACTIONS,
        'HandleLidSwitch' => Common::SESSION_ACTIONS,
        'HandleLidSwitchDocked' => Common::SESSION_ACTIONS,
        'PowerKeyIgnoreInhibited' => Common::BOOLEAN,
        'SuspendKeyIgnoreInhibited' => Common::BOOLEAN,
        'HibernateKeyIgnoreInhibited' => Common::BOOLEAN,
        'LidSwitchIgnoreInhibited' => Common::BOOLEAN,
        'HoldoffTimeoutSec' => Common::STRING_OR_INT,
        'RuntimeDirectorySize' => Common::STRING_OR_INT,
        'InhibitorsMax' => Common::INTEGER,
        'SessionsMax' => Common::INTEGER,
        'UserTasksMax' => Common::INTEGER,
        'RemoveIPC' => Common::BOOLEAN,
      },
    }.freeze
  end

  module Link
    OPTIONS ||= {
      'Match' => {
        'MACAddress' => Common::STRING,
        'OriginalName' => Common::ARRAY,
        'Path' => Common::ARRAY,
        'Driver' => Common::ARRAY,
        'Type' => Common::ARRAY,
        'Host' => Common::STRING,
        'Virtualization' => Common::VIRT,
        'KernelCommandLine' => Common::STRING,
        'Architecture' => Common::ARCH,
      },
      'Link' => {
        'Description' => Common::STRING,
        'Alias' => Common::STRING,
        'MACAddressPolicy' => {
          kind_of: String,
          equal_to: %w(persistent random none),
        },
        'MACAddress' => Common::STRING,
        'NamePolicy' => {
          kind_of: [String, Array],
          callbacks: {
            'is a valid policy' => lambda do |spec|
              %w(kernel database onboard slot path mac).include?(spec)
            end,
          },
        },
        'Name' => Common::STRING,
        'MTUBytes' => Common::STRING_OR_INT,
        'BitsPerSecond' => Common::STRING_OR_INT,
        'Duplex' => {
          kind_of: String,
          equal_to: %w(half full),
        },
        'AutoNegotiation' => Common::BOOLEAN,
        'WakeOnLan' => {
          kind_of: String,
          equal_to: %w(phy unicast multicast broadcast arp magic secureon off),
        },
        'Port' => {
          kind_of: String,
          equal_to: %w(tp aui bnc mii fibre),
        },
        'TCPSegmentationOffload' => Common::BOOLEAN,
        'TCP6SegmentationOffload' => Common::BOOLEAN,
        'GenericSegmentationOffload' => Common::BOOLEAN,
        'LargeReceiveOffload' => Common::BOOLEAN,
      },
    }.freeze
  end

  module Netdev
    OPTIONS ||= {
      'Match' => {
        'Host' => Common::STRING,
        'Virtualization' => Common::VIRT,
        'KernelCommandLine' => Common::STRING,
        'Architecture' => Common::ARCH,
      },
      'NetDev' => {
        'Description' => Common::STRING,
        'Name' => {
          kind_of: String,
        },
        'Kind' => {
          kind_of: String,
          equal_to: %w(
            bond
            bridge
            dummy
            gre
            gretap
            ip6gre
            ip6tnl
            ip6gretap
            ipip
            ipvlan
            macvlan
            macvtap
            sit
            tap
            tun
            veth
            vlan
            vti
            vti6
            vxlan
            geneve
            vrf
            vcan
            vxcan
          ),
        },
        'MTUBytes' => Common::STRING_OR_INT,
        'MACAddress' => Common::STRING,
      },
      'Bridge' => {
        'HelloTimeSec' => Common::STRING_OR_INT,
        'MaxAgeSec' => Common::STRING_OR_INT,
        'ForwardDelaySec' => Common::STRING_OR_INT,
        'AgeingTimeSec' => Common::STRING_OR_INT,
        'Priority' => { kind_of: Integer, equal_to: (0..65535).to_a },
        'GroupForwardMask' => Common::STRING,
        'DefaultPVID' => { kind_of: [String, Integer], equal_to: (1..4094).to_a.push('none') },
        'MulticastQuerier' => Common::BOOLEAN,
        'MulticastSnooping' => Common::BOOLEAN,
        'VLANFiltering' => Common::BOOLEAN,
        'STP' => Common::BOOLEAN,
      },
      'VLAN' => {
        'Id' => {
          kind_of: Integer,
          equal_to: 0.upto(4094).to_a,
        },
        'GVRP' => Common::BOOLEAN,
        'MVRP' => Common::BOOLEAN,
        'LooseBinding' => Common::BOOLEAN,
        'ReorderHeader' => Common::BOOLEAN,
      },
      'MACVLAN' => {
        'Mode' => {
          kind_of: String,
          equal_to: %w(private vepa bridge passthru),
        },
      },
      'MACVTAP' => {
        'Mode' => {
          kind_of: String,
          equal_to: %w(private vepa bridge passthru),
        },
      },
      'IPVLAN' => {
        'Mode' => {
          kind_of: String,
          equal_to: %w(L2 L3),
        },
      },
      'VXLAN' => {
        'Id' => Common::INTEGER,
        'Remote' => Common::STRING,
        'Local' => Common::STRING,
        'Group' => Common::STRING,
        'TOS' => Common::STRING,
        'TTL' => {
          kind_of: Integer,
          equal_to: 0.upto(255).to_a,
        },
        'MacLearning' => Common::BOOLEAN,
        'FDBAgeingSec' => Common::STRING_OR_INT,
        'MaximumFDBEntries' => Common::INTEGER,
        'ARPProxy' => Common::BOOLEAN,
        'ReduceARPProxy' => Common::BOOLEAN,
        'L2MissNotification' => Common::BOOLEAN,
        'L3MissNotification' => Common::BOOLEAN,
        'RouteShortCircuit' => Common::BOOLEAN,
        'UDPCheckSum' => Common::BOOLEAN,
        'UDP6ZeroChecksumTx' => Common::BOOLEAN,
        'UDP6ZeroChecksumRx' => Common::BOOLEAN,
        'RemoteChecksumTx' => Common::BOOLEAN,
        'RemoteChecksumRx' => Common::BOOLEAN,
        'GroupPolicyExtension' => Common::BOOLEAN,
        'DestinationPort' => {
          kind_of: Integer,
          equal_to: 0.upto(65_535).to_a,
        },
        'PortRange' => Common::STRING,
        'FlowLabel' => Common::INTEGER,
      },
      'GENEVE' => {
        'Id' => { kind_of: Integer, equal_to: 0.upto(16_777_215).to_a },
        'Remote' => Common::STRING,
        'TOS' => { kind_of: Integer, equal_to: 1.upto(255).to_a },
        'TTL' => { kind_of: Integer, equal_to: 1.upto(255).to_a },
        'UDPChecksum' => Common::BOOLEAN,
        'UDP6ZeroChecksumTx' => Common::BOOLEAN,
        'UDP6ZeroChecksumRx' => Common::BOOLEAN,
        'DestinationPort' => {
          kind_of: Integer,
          equal_to: 0.upto(65_535).to_a,
        },
        'FlowLabel' => Common::INTEGER,
      },
      'Tunnel' => {
        'Local' => Common::STRING,
        'Remote' => Common::STRING,
        'TOS' => Common::STRING,
        'TTL' => Common::STRING,
        'DiscoverPathMTU' => Common::BOOLEAN,
        'IPv6FlowLabel' => Common::STRING,
        'CopyDSCP' => Common::BOOLEAN,
        'EncapsulationLimit' => {
          kind_of: [String, Integer],
          equal_to: 0.upto(255).to_a.push('none'),
        },
        'Key' => Common::STRING_OR_INT,
        'InputKey' => Common::STRING_OR_INT,
        'OutputKey' => Common::STRING_OR_INT,
        'Mode' => {
          kind_of: String,
          equal_to: %w(ip6ip6 ipip6 any),
        },
        'Independent' => Common::BOOLEAN,
      },
      'Peer' => {
        'Name' => Common::STRING,
        'MACAddress' => Common::STRING,
      },
      'VXCAN' => {
        'Peer' => Common::STRING,
      },
      'Tun' => {
        'OneQueue' => Common::BOOLEAN,
        'MultiQueue' => Common::BOOLEAN,
        'PacketInfo' => Common::BOOLEAN,
        'VNetHeader' => Common::BOOLEAN,
        'User' => Common::STRING,
        'Group' => Common::STRING,
      },
      'Tap' => {
        'OneQueue' => Common::BOOLEAN,
        'MultiQueue' => Common::BOOLEAN,
        'PacketInfo' => Common::BOOLEAN,
        'VNetHeader' => Common::BOOLEAN,
        'User' => Common::STRING,
        'Group' => Common::STRING,
      },
      'Bond' => {
        'Mode' => {
          kind_of: String,
          equal_to: %w(
            balance-rr
            active-backup
            balance-xor
            broadcast
            802.3ad
            balance-tlb
            balance-alb
          ),
        },
        'TransmitHashPolicy' => {
          kind_of: String,
          equal_to: %w(
            layer2
            layer3+4
            layer2+3
            encap2+3
            encap3+4
          ),
        },
        'LACPTransmitRate' => {
          kind_of: String,
          equal_to: %w(fast slow),
        },
        'MIIMonitorSec' => Common::STRING_OR_INT,
        'UpDelaySec' => Common::STRING_OR_INT,
        'DownDelaySec' => Common::STRING_OR_INT,
        'LearnPacketIntervalSec' => Common::STRING_OR_INT,
        'AdSelect' => {
          kind_of: String,
          equal_to: %w(stable bandwidth count),
        },
        'FailOverMACPolicy' => {
          kind_of: String,
          equal_to: %w(none active follow),
        },
        'ARPValidate' => {
          kind_of: String,
          equal_to: %w(none active backup all),
        },
        'ARPIntervalSec' => Common::STRING_OR_INT,
        'ARPIPTargets' => Common::STRING_OR_INT,
        'ARPAllTargets' => Common::ARRAY,
        'PrimaryReselectPolicy' => {
          kind_of: String,
          equal_to: %w(any all),
        },
        'ResendIGMP' => {
          kind_of: Integer,
          equal_to: 0.upto(255).to_a,
        },
        'PacketsPerSlave' => {
          kind_of: Integer,
          equal_to: 0.upto(65_535).to_a,
        },
        'GratuitousARP' => {
          kind_of: Integer,
          equal_to: 0.upto(255).to_a,
        },
        'AllSlavesActive' => Common::BOOLEAN,
        'MinLinks' => Common::INTEGER,
      },
    }.freeze
  end

  module Network
    OPTIONS ||= {
      'Match' => {
        'MACAddress' => Common::STRING,
        'Path' => Common::ARRAY,
        'Driver' => Common::ARRAY,
        'Type' => Common::ARRAY,
        'Name' => Common::ARRAY,
        'Host' => Common::STRING,
        'Virtualization' => Common::VIRT,
        'KernelCommandLine' => Common::STRING,
        'Architecture' => Common::ARCH,
      },
      'Link' => {
        'MACAddress' => Common::STRING,
        'MTUBytes' => Common::STRING_OR_INT,
        'ARP' => Common::BOOLEAN,
        'Unmanaged' => Common::BOOLEAN,
        'RequiredForOnline' => Common::BOOLEAN,
      },
      'Network' => {
        'Description' => Common::STRING,
        'DHCP' => {
          kind_of: [String, Integer, TrueClass, FalseClass],
          equal_to: %w(yes no ipv4 ipv6).concat([true, false]),
        },
        'DHCPServer' => Common::BOOLEAN,
        'LinkLocalAddressing' => {
          kind_of: [String, Integer],
          equal_to: %w(yes no ipv4 ipv6).concat([true, false]),
        },
        'IPv4LLRoute' => Common::BOOLEAN,
        'IPv6Token' => Common::STRING,
        'LLMNR' => {
          kind_of: [String, Integer, TrueClass, FalseClass],
          equal_to: ['resolve', true, false],
        },
        'MulticastDNS' => {
          kind_of: [String, Integer, TrueClass, FalseClass],
          equal_to: ['resolve', true, false],
        },
        'DNSSEC' => {
          kind_of: [String, Integer, TrueClass, FalseClass],
          equal_to: ['allow-downgrade', true, false],
        },
        'DNSSECNegativeTrustAnchors' => Common::ARRAY,
        'LLDP' => {
          kind_of: [String, Integer, TrueClass, FalseClass],
          equal_to: ['routers-only', true, false],
        },
        'EmitLLDP' => {
          kind_of: [TrueClass, FalseClass, String],
          equal_to: %w(
            nearest-bridge
            non-tpmr-bridge
            customer-bridge
          ).concat([true, false]),
        },
        'BindCarrier' => Common::ARRAY,
        'Address' => Common::STRING,
        'Gateway' => Common::STRING,
        'DNS' => Common::STRING,
        'Domains' => Common::ARRAY,
        'NTP' => Common::STRING,
        'IPForward' => {
          kind_of: [TrueClass, FalseClass, String],
          equal_to: [true, false, 'ipv4', 'ipv6'],
        },
        'IPMasquerade' => Common::BOOLEAN,
        'IPv6PrivacyExtensions' => {
          kind_of: [TrueClass, FalseClass, String],
          equal_to: [true, false, 'prefer-public', 'kernel'],
        },
        'IPv6AcceptRA' => Common::BOOLEAN,
        'IPv6AcceptRouterAdvertisements' => Common::BOOLEAN,
        'IPv6DuplicateAddressDetection' => Common::INTEGER,
        'IPv6HopLimit' => Common::INTEGER,
        'IPv4ProxyARP' => Common::BOOLEAN,
        'IPv6ProxyNDP' => Common::BOOLEAN,
        'IPv6ProxyNDPAddress' => Common::STRING,
        'IPv6PrefixDelegation' => Common::BOOLEAN,
        'ProxyARP' => Common::BOOLEAN,
        'Bridge' => Common::STRING,
        'Bond' => Common::STRING,
        'VRF' => Common::STRING,
        'VLAN' => Common::STRING,
        'MACVLAN' => Common::STRING,
        'VXLAN' => Common::STRING,
        'Tunnel' => Common::STRING,
        'ActiveSlave' => Common::BOOLEAN,
        'PrimarySlave' => Common::BOOLEAN,
        'ConfigureWithoutCarrier' => Common::BOOLEAN,
      },
      'Address' => {
        'Address' => Common::STRING,
        'Peer' => Common::STRING,
        'Broadcast' => Common::STRING,
        'Label' => Common::STRING,
        'PreferredLifetime' => {
          kind_of: [String, Integer],
          equal_to: ['forever', 'infinity', 0],
        },
        'Scope' => {
          kind_of: [Integer, String],
          equal_to: 0.upto(255).to_a.concat(%w(global link host)),
        },
        'HomeAddress' => Common::BOOLEAN,
        'DuplicateAddressDetection' => Common::BOOLEAN,
        'ManageTemporaryAddress' => Common::BOOLEAN,
        'PrefixRoute' => Common::BOOLEAN,
        'AutoJoin' => Common::BOOLEAN,
      },
      'IPv6AddressLabel' => {
        'Label' => Common::INTEGER,
        'Prefix' => Common::STRING,
      },
      'RoutingPolicyRule' => {
        'TypeOfService' => { kind_of: Integer, equal_to: 0.upto(255).to_a },
        'From' => Common::STRING,
        'To' => Common::STRING,
        'FirewallMark' => Common::INTEGER,
        'Table' => Common::INTEGER,
        'Priority' => Common::INTEGER,
        'IncomingInterface' => Common::STRING,
        'OutgoingInterface' => Common::STRING,
      },
      'Route' => {
        'Gateway' => Common::STRING,
        'GatewayOnlink' => Common::BOOLEAN,
        'Destination' => Common::STRING,
        'Source' => Common::STRING,
        'Metric' => Common::INTEGER,
        'IPv6Preference' => { kind_of: String, equal_to: %w(low medium high) },
        'Scope' => {
          kind_of: String,
          equal_to: %w(global link host),
        },
        'PreferredSource' => Common::STRING,
        'Table' => Common::INTEGER,
        'Protocol' => {
          kind_of: [Integer, String],
          equal_to: 0.upto(255).to_a.concat(%w(kernel boot static)),
        },
        'Type' => Common::STRING,
      },
      'DHCP' => {
        'UseDNS' => Common::BOOLEAN,
        'UseNTP' => Common::BOOLEAN,
        'UseMTU' => Common::BOOLEAN,
        'Anonymize' => Common::BOOLEAN,
        'SendHostname' => Common::BOOLEAN,
        'UseHostame' => Common::BOOLEAN,
        'Hostname' => Common::STRING,
        'UseDomains' => {
          kind_of: [TrueClass, FalseClass, String],
          equal_to: [true, false, 'route'],
        },
        'UseRoutes' => Common::BOOLEAN,
        'UseTimezone' => Common::BOOLEAN,
        'CriticalConnection' => Common::BOOLEAN,
        'ClientIdentifier' => {
          kind_of: String,
          equal_to: %w(mac duid),
        },
        'VendorClassIdentifier' => Common::STRING,
        'DUIDType' => {
          kind_of: String,
          equal_to: %w(vendor link-layer-time link-layer uuid),
        },
        'DUIDRawData' => Common::STRING,
        'IAID' => Common::INTEGER,
        'RequestBroadcast' => Common::BOOLEAN,
        'RouteMetric' => Common::INTEGER,
        'RouteTable' => Common::INTEGER,
        'ListenPort' => Common::INTEGER,
      },
      'IPv6AcceptRA' => {
        'UseDNS' => Common::BOOLEAN,
        'UseDomains' => {
          kind_of: [TrueClass, FalseClass, String],
          equal_to: [true, false, 'route'],
        },
        'RouteTable' => Common::INTEGER,
      },
      'DHCPServer' => {
        'PoolOffset' => Common::STRING,
        'PoolSize' => Common::INTEGER,
        'DefaultLeaseTimeSec' => Common::STRING_OR_INT,
        'MaxLeaseTimeSec' => Common::STRING_OR_INT,
        'EmitDNS' => Common::BOOLEAN,
        'DNS' => Common::ARRAY,
        'EmitNTP' => Common::BOOLEAN,
        'NTP' => Common::ARRAY,
        'EmitRouter' => Common::BOOLEAN,
        'EmitTimezone' => Common::BOOLEAN,
        'Timezone' => Common::STRING,
      },
      'IPv6PrefixDelegation' => {
        'Managed' => Common::BOOLEAN,
        'OtherInformation' => Common::BOOLEAN,
        'RouterLifetimeSec' => Common::STRING_OR_INT,
        'EmitDNS' => Common::BOOLEAN,
        'DNS' => Common::ARRAY,
        'EmitDomains' => Common::BOOLEAN,
        'Domains' => Common::STRING_OR_ARRAY,
        'DNSLifetimeSec' => Common::STRING_OR_INT,
      },
      'IPv6Prefix' => {
        'AddressAutoconfiguration' => Common::BOOLEAN,
        'OnLink' => Common::BOOLEAN,
        'Prefix' => Common::STRING,
        'PreferredLifetimeSec' => Common::STRING_OR_INT,
        'ValidLifetimeSec' => Common::STRING_OR_INT,
      },
      'Bridge' => {
        'UnicastFlood' => Common::BOOLEAN,
        'HairPin' => Common::BOOLEAN,
        'UseBPDU' => Common::BOOLEAN,
        'FastLeave' => Common::BOOLEAN,
        'AllowPortToBeRoot' => Common::BOOLEAN,
        'Cost' => Common::INTEGER,
        'Priority' => { kind_of: Integer, equal_to: 0.upto(63).to_a },
      },
      'BridgeFDB' => {
        'MACAddress' => Common::STRING,
        'VLANId' => Common::INTEGER,
      },
      'BridgeVLAN' => {
        'VLAN' => Common::INTEGER,
        'EgressUntagged' => Common::STRING_OR_INT,
        'PVID' => Common::INTEGER,
      },
    }.freeze
  end

  module Resolved
    OPTIONS ||= {
      'Resolve' => {
        'DNS' => Common::STRING_OR_ARRAY,
        'FallbackDNS' => Common::STRING_OR_ARRAY,
        'Domains' => Common::STRING_OR_ARRAY,
        'LLMNR' => {
          kind_of: [String, TrueClass, FalseClass],
          equal_to: [true, false, 'resolve'],
        },
        'MulticastDNS' => {
          kind_of: [TrueClass, FalseClass, String],
          equal_to: [true, false, 'resolve'],
        },
        'DNSSEC' => {
          kind_of: [String, TrueClass, FalseClass],
          equal_to: [true, false, 'allow-downgrade'],
        },
        'Cache' => Common::BOOLEAN,
        'DNSStubListener' => {
          kind_of: [String, TrueClass, FalseClass],
          equal_to: [true, false, 'tcp', 'udp'],
        },
      },
    }.freeze
  end

  module Sleep
    OPTIONS ||= {
      'Sleep' => {
        'SuspendMode' => Common::STRING_OR_ARRAY,
        'HibernateMode' => Common::STRING_OR_ARRAY,
        'HybridSleepMode' => Common::STRING_OR_ARRAY,
        'SuspendState' => Common::STRING_OR_ARRAY,
        'HibernateState' => Common::STRING_OR_ARRAY,
        'HybridSleepState' => Common::STRING_OR_ARRAY,
      },
    }.freeze
  end

  module System
    OPTIONS ||= {
      'Manager' => {
        'LogLevel' => Common::LOGLEVEL,
        'LogTarget' => {
          kind_of: String,
          equal_to: %w(console journal kmsg journal-or-kmsg null),
        },
        'LogColor' => Common::BOOLEAN,
        'LogLocation' => Common::BOOLEAN,
        'DumpCore' => Common::BOOLEAN,
        'CrashChVT' => Common::BOOLEAN,
        'CrashChangeVT' => Common::BOOLEAN,
        'CrashShell' => Common::BOOLEAN,
        'CrashReboot' => Common::BOOLEAN,
        'ShowStatus' => Common::BOOLEAN,
        'DefaultStandardOutput' => Exec::OPTIONS['StandardOutput'],
        'DefaultStandardError' => Exec::OPTIONS['StandardError'],
        'CPUAffinity' => Common::ARRAY,
        'JoinControllers' => Common::ARRAY,
        'RuntimeWatchdogSec' => Common::STRING_OR_INT,
        'ShutdownWatchdogSec' => Common::STRING_OR_INT,
        'WatchdogDevice' => Common::STRING,
        'CapabilityBoundingSet' => Common::CAP,
        'SystemCallArchitectures' => {
          kind_of: [String, Array],
          callbacks: {
            'is valid arch' => lambda do |spec|
              Array(spec).all? do |a|
                %w(x86 x86-64 x32 arm native).include?(a)
              end
            end,
          },
        },
        'TimerSlackNSec' => Common::STRING_OR_INT,
        'DefaultTimerAccuracySec' => Timer::OPTIONS['Timer']['AccuracySec'],
        'DefaultTimeoutStartSec' => Service::OPTIONS['Service']['TimeoutStartSec'],
        'DefaultTimeoutStopSec' => Service::OPTIONS['Service']['TimeoutStopSec'],
        'DefaultRestartSec' => Service::OPTIONS['Service']['RestartSec'],
        'DefaultStartLimitInterval' => Unit::OPTIONS['Unit']['StartLimitIntervalSec'],
        'DefaultStartLimitIntervalSec' => Unit::OPTIONS['Unit']['StartLimitIntervalSec'],
        'DefaultStartLimitBurst' => Unit::OPTIONS['Unit']['StartLimitBurst'],
        'DefaultEnvironment' => Exec::OPTIONS['Environment'],
        'DefaultCPUAccounting' => ResourceControl::OPTIONS['CPUAccounting'],
        'DefaultBlockIOAccounting' => ResourceControl::OPTIONS['BlockIOAccounting'],
        'DefaultMemoryAccounting' => ResourceControl::OPTIONS['MemoryAccounting'],
        'DefaultTasksAccounting' => ResourceControl::OPTIONS['TasksAccounting'],
        'DefaultIPAccounting' => ResourceControl::OPTIONS['IPAccounting'],
        'DefaultTasksMax' => ResourceControl::OPTIONS['TasksMax'],
        'DefaultLimitCPU' => Exec::OPTIONS['LimitCPU'],
        'DefaultLimitFSIZE' => Exec::OPTIONS['LimitFSIZE'],
        'DefaultLimitDATA' => Exec::OPTIONS['LimitDATA'],
        'DefaultLimitSTACK' => Exec::OPTIONS['LimitSTACK'],
        'DefaultLimitCORE' => Exec::OPTIONS['LimitCORE'],
        'DefaultLimitRSS' => Exec::OPTIONS['LimitRSS'],
        'DefaultLimitNOFILE' => Exec::OPTIONS['LimitNOFILE'],
        'DefaultLimitAS' => Exec::OPTIONS['LimitAS'],
        'DefaultLimitNPROC' => Exec::OPTIONS['LimitNPROC'],
        'DefaultLimitMEMLOCK' => Exec::OPTIONS['LimitMEMLOCK'],
        'DefaultLimitLOCKS' => Exec::OPTIONS['LimitLOCKS'],
        'DefaultLimitSIGPENDING' => Exec::OPTIONS['LimitSIGPENDING'],
        'DefaultLimitMSGQUEUE' => Exec::OPTIONS['LimitMSGQUEUE'],
        'DefaultLimitNICE' => Exec::OPTIONS['LimitNICE'],
        'DefaultLimitRTPRIO' => Exec::OPTIONS['LimitRTPRIO'],
        'DefaultLimitRTTIME' => Exec::OPTIONS['LimitRTTIME'],
      },
    }.freeze
  end

  module Timesyncd
    OPTIONS ||= {
      'Time' => {
        'NTP' => Common::STRING_OR_ARRAY,
        'FallbackNTP' => Common::STRING_OR_ARRAY,
        'RootDistanceMaxSec' => Common::STRING_OR_INT,
        'PollIntervalMinSec' => Common::STRING_OR_INT,
        'PollIntervalMaxSec' => Common::STRING_OR_INT,
      },
    }.freeze
  end

  module User
    OPTIONS ||= System::OPTIONS
  end

  module Nspawn
    OPTIONS ||= {
      'Exec' => {
        'Boot' => Common::BOOLEAN,
        'ProcessTwo' => Common::BOOLEAN,
        'Parameters' => Common::ARRAY,
        'Environment' => { kind_of: [String, Array, Hash] },
        'User' => Common::STRING,
        'WorkingDirectory' => Common::ABSOLUTE_PATH,
        'PivotRoot' => Common::STRING,
        'Capability' => Common::ARRAY,
        'DropCapability' => Common::ARRAY,
        'KillSignal' => Common::STRING_OR_INT,
        'Personality' => Common::ARCH,
        'MachineID' => Common::STRING,
        'PrivateUsers' => {
          kind_of: [TrueClass, FalseClass, String, Integer],
        },
        'NotifyReady' => Common::BOOLEAN,
        'SystemCallFilter' => Common::STRING_OR_ARRAY,
      },
      'Files' => {
        'ReadOnly' => Common::BOOLEAN,
        'Volatile' => {
          kind_of: [TrueClass, FalseClass, String],
          equal_to: [true, false, 'state', 'yes', 'no'],
        },
        'Bind' => Common::STRING,
        'BindReadOnly' => Common::STRING,
        'TemporaryFileSystem' => Common::STRING,
        'Overlay' => Common::STRING,
        'OverlayReadOnly' => Common::STRING,
        'PrivateUsersChown' => Common::BOOLEAN,
      },
      'Network' => {
        'Private' => Common::BOOLEAN,
        'VirtualEthernet' => Common::BOOLEAN,
        'VirtualEthernetExtra' => Common::STRING,
        'Interface' => Common::ARRAY,
        'MACVLAN' => Common::ARRAY,
        'IPVLAN' => Common::ARRAY,
        'Bridge' => Common::STRING,
        'Zone' => Common::STRING,
        'Port' => Common::STRING_OR_INT,
      },
    }.freeze
  end

  module JournalUpload
    OPTIONS ||= {
      'Upload' => {
        'URL' => Common::STRING,
        'ServerKeyFile' => Common::ABSOLUTE_PATH,
        'ServerCertificateFile' => Common::ABSOLUTE_PATH,
        'TrustedCertificateFile' => Common::ABSOLUTE_PATH,
      },
    }.freeze
  end

  module JournalRemote
    OPTIONS ||= {
      'Remote' => {
        'Seal' => Common::BOOLEAN,
        'SplitMode' => { kind_of: String, equal_to: %w(none host) },
        'ServerKeyFile' => Common::ABSOLUTE_PATH,
        'ServerCertificateFile' => Common::ABSOLUTE_PATH,
        'TrustedCertificateFile' => Common::ABSOLUTE_PATH,
      },
    }.freeze
  end
end
