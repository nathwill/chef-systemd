# http://www.freedesktop.org/software/systemd/man/systemd.automount.html
#
# Cookbook Name:: systemd
# Module:: Systemd::Automount
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

require_relative 'helpers'

module Systemd
  module Automount
    OPTIONS ||= {
      'Where' => {},
      'DirectoryMode' => { kind_of: [Integer, String] },
      'TimeoutIdleSec' => { kind_of: [Integer, String] }
    }
  end

  module Bootchart
    OPTIONS ||= {
      'Samples' => { kind_of: Integer },
      'Frequency' => { kind_of: Integer },
      'Relative' => { kind_of: [TrueClass, FalseClass] },
      'Filter' => { kind_of: [TrueClass, FalseClass] },
      'Output' => {},
      'Init' => {},
      'PlotMemoryUsage' => { kind_of: [TrueClass, FalseClass] },
      'PlotEntropyGraph' => { kind_of: [TrueClass, FalseClass] },
      'ScaleX' => { kind_of: Integer },
      'ScaleY' => { kind_of: Integer },
      'ControlGroup' => { kind_of: [TrueClass, FalseClass] }
    }
  end

  module Coredump
    OPTIONS ||= {
      'Storage' => {
        kind_of: String,
        equal_to: %w( none external journal both )
      },
      'Compress' => { kind_of: [TrueClass, FalseClass] },
      'ProcessSizeMax' => { kind_of: Integer },
      'ExternalSizeMax' => { kind_of: Integer },
      'JournalSizeMax' => { kind_of: Integer },
      'MaxUse' => {},
      'KeepFree' => {}
    }
  end

  module Device
    OPTIONS ||= {}
  end

  # rubocop: disable ModuleLength
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
  # rubocop: enable ModuleLength

  module Install
    # excluded Alias option due to conflict with ruby reserved words
    OPTIONS ||= {
      'WantedBy' => { kind_of: [String, Array] },
      'RequiredBy' => { kind_of: [String, Array] },
      'Also' => { kind_of: [String, Array] },
      'DefaultInstance' => {}
    }
  end

  module Journald
    OPTIONS ||= {
      'Storage' => {
        kind_of: String,
        equal_to: %w( volatile persistent auto none )
      },
      'Compress' => { kind_of: [TrueClass, FalseClass] },
      'Seal' => { kind_of: [TrueClass, FalseClass] },
      'SplitMode' => { kind_of: String, equal_to: %w( uid login none ) },
      'RateLimitInterval' => {},
      'RateLimitBurst' => {},
      'SystemMaxUse' => {},
      'SystemKeepFree' => {},
      'SystemMaxFileSize' => {},
      'RuntimeMaxUse' => {},
      'RuntimeKeepFree' => {},
      'RuntimeMaxFileSize' => {},
      'MaxFileSec' => { kind_of: [String, Integer] },
      'MaxRetentionSec' => { kind_of: [String, Integer] },
      'SyncIntervalSec' => { kind_of: [String, Integer] },
      'ForwardToSyslog' => { kind_of: [TrueClass, FalseClass] },
      'ForwardToKMsg' => { kind_of: [TrueClass, FalseClass] },
      'ForwardToConsole' => { kind_of: [TrueClass, FalseClass] },
      'ForwardToWall' => { kind_of: [TrueClass, FalseClass] },
      'MaxLevelStore' => {},
      'MaxLevelSyslog' => {},
      'MaxLevelKMsg' => {},
      'MaxLevelConsole' => {},
      'MaxLevelWall' => {},
      'TTYPath' => {}
    }
  end

  module JournalRemote
    OPTIONS ||= {
      'SplitMode' => { kind_of: String, equal_to: %w( host none ) },
      'ServerKeyFile' => {},
      'ServerCertificateFile' => {},
      'TrustedCertificateFile' => {}
    }
  end

  module Kill
    OPTIONS ||= {
      'KillMode' => {
        kind_of: String,
        equal_to: %w( control-group process mixed none )
      },
      'KillSignal' => {},
      'SendSIGHUP' => { kind_of: [TrueClass, FalseClass] },
      'SendSIGKILL' => { kind_of: [TrueClass, FalseClass] }
    }
  end

  module Locale
    OPTIONS ||= {
      'LANG' => {},
      'LANGUAGE' => {},
      'LC_CTYPE' => {},
      'LC_NUMERIC' => {},
      'LC_TIME' => {},
      'LC_COLLATE' => {},
      'LC_MONETARY' => {},
      'LC_MESSAGES' => {},
      'LC_PAPER' => {},
      'LC_NAME' => {},
      'LC_ADDRESS' => {},
      'LC_TELEPHONE' => {},
      'LC_MEASUREMENT' => {},
      'LC_IDENTIFICATION' => {}
    }
  end

  module Logind
    POWER_OPTS ||= {
      kind_of: String,
      equal_to: %w(
        ignore poweroff reboot halt kexec
        suspend hibernate hybrid-sleep lock
      )
    }

    OPTIONS ||= {
      'NAutoVTs' => {
        kind_of: Integer,
        callbacks: {
          'is a valid argument' => lambda do |spec|
            spec >= 0
          end
        }
      },
      'ReserveVT' => {
        kind_of: Integer,
        callbacks: {
          'is a valid argument' => lambda do |spec|
            spec >= 0
          end
        }
      },
      'KillUserProcesses' => { kind_of: [TrueClass, FalseClass] },
      'KillOnlyUsers' => { kind_of: [String, Array] },
      'KillExcludeUsers' => { kind_of: [String, Array] },
      'IdleAction' => POWER_OPTS,
      'IdleActionSec' => { kind_of: [String, Integer] },
      'InhibitDelayMaxSec' => { kind_of: [String, Integer] },
      'HandlePowerKey' => POWER_OPTS,
      'HandleSuspendKey' => POWER_OPTS,
      'HandleHibernateKey' => POWER_OPTS,
      'HandleLidSwitch' => POWER_OPTS,
      'HandleLidSwitchDocked' => POWER_OPTS,
      'PowerKeyIgnoreInhibited' => { kind_of: [TrueClass, FalseClass] },
      'SuspendKeyIgnoreInhibited' => { kind_of: [TrueClass, FalseClass] },
      'HibernateKeyIgnoreInhibited' => { kind_of: [TrueClass, FalseClass] },
      'LidSwitchIgnoreInhibited' => { kind_of: [TrueClass, FalseClass] },
      'HoldoffTimeoutSec' => { kind_of: [String, Integer] },
      'RuntimeDirectorySize' => {},
      'RemoveIPC' => { kind_of: [TrueClass, FalseClass] }
    }
  end

  module ResourceControl
    OPTIONS ||= {
      'CPUAccounting' => { kind_of: [TrueClass, FalseClass] },
      'CPUShares' => { kind_of: Integer },
      'StartupCPUShares' => { kind_of: Integer },
      'CPUQuota' => {},
      'MemoryAccounting' => { kind_of: [TrueClass, FalseClass] },
      'MemoryLimit' => {},
      'BlockIOAccounting' => { kind_of: [TrueClass, FalseClass] },
      'BlockIOWeight' => { kind_of: Integer, equal_to: 10.upto(1_000) },
      'StartupBlockIOWeight' => { kind_of: Integer, equal_to: 10.upto(1_000) },
      'BlockIODeviceWeight' => {},
      'BlockIOReadBandwidth' => {},
      'BlockIOWriteBandwidth' => {},
      'DeviceAllow' => {},
      'DevicePolicy' => { kind_of: String, equal_to: %w( strict closed auto ) },
      'Slice' => {},
      'Delegate' => { kind_of: [TrueClass, FalseClass] }
    }
  end

  module Mount
    OPTIONS ||= Systemd::ResourceControl::OPTIONS
                .merge(Systemd::Exec::OPTIONS)
                .merge(Systemd::Kill::OPTIONS)
                .merge('What' => {},
                       'Where' => {},
                       'Type' => {},
                       'Options' => {},
                       'SloppyOptions' => { kind_of: [TrueClass, FalseClass] },
                       'DirectoryMode' => { kind_of: [String, Integer] },
                       'TimeoutSec' => { kind_of: [String, Integer] })
  end

  module Networkd
    module Link
      OPTIONS ||= {
        'Description' => {},
        'MACAddressPolicy' => {
          kind_of: String,
          equal_to: %w( persistent random )
        },
        'NamePolicy' => {
          kind_of: [String, Array],
          callbacks: {
            'is a valid argument' => lambda do |spec|
              Array(spec).all? do |arg|
                %w( kernel database onboard slot path mac ).include? arg
              end
            end
          }
        },
        'Name' => {},
        'MTUBytes' => { kind_of: [String, Integer] },
        'BitsPerSecond' => { kind_of: [String, Integer] },
        'Duplex' => { kind_of: String, equal_to: %w( half full ) },
        'WakeOnLan' => { kind_of: String, equal_to: %w( phy magic off ) }
      }
    end

    module Match
      OPTIONS ||= {
        'OriginalName' => { kind_of: [String, Array] },
        'Path' => { kind_of: [String, Array] },
        'Driver' => { kind_of: [String, Array] },
        'Type' => { kind_of: [String, Array] },
        'Host' => {},
        'Virtualization' => {
          kind_of: [TrueClass, FalseClass, String],
          equal_to: [
            true, false, 'vm', 'container', 'qemu', 'kvm', 'zvm',
            'vmware', 'microsoft', 'oracle', 'xen', 'bochs', 'uml',
            'openvz', 'lxc', 'lxc-libvirt', 'systemd-nspawn', 'docker'
          ]
        },
        'KernelCommandLine' => {},
        'Architecture' => {
          kind_of: String,
          equal_to: %w(
            x86 x86-64 ppc ppc-le ppc64 ppc64-le ia64 parisc parisc64
            s390 s390x sparc sparc64 mips mips-le mips64 mips64-le
            alpha arm arm-be arm64 arm64-be sh sh64 m86k tilegx cris
          )
        }
      }
    end

    OPTIONS ||= Systemd::Networkd::Match::OPTIONS
                .merge Systemd::Networkd::Link::OPTIONS
  end

  module Resolved
    OPTIONS ||= {
      'DNS' => { kind_of: [String, Array] },
      'FallbackDNS' => { kind_of: [String, Array] },
      'LLMNR' => {
        kind_of: [TrueClass, FalseClass, String],
        equal_to: [true, false, 'resolve']
      }
    }
  end

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

  module Sleep
    OPTIONS ||= {
      'SuspendMode' => { kind_of: [String, Array] },
      'HibernateMode' => { kind_of: [String, Array] },
      'HybridSleepMode' => { kind_of: [String, Array] },
      'SuspendState' => { kind_of: [String, Array] },
      'HibernateState' => { kind_of: [String, Array] },
      'HybridSleepState' => { kind_of: [String, Array] }
    }
  end

  module Slice
    OPTIONS ||= Systemd::ResourceControl::OPTIONS
  end

  module Socket
    OPTIONS ||= Systemd::ResourceControl::OPTIONS
                .merge(Systemd::Exec::OPTIONS)
                .merge(Systemd::Kill::OPTIONS)
                .merge('ListenStream' => {},
                       'ListenDatagram' => {},
                       'ListenSequentialPacket' => {},
                       'ListenFIFO' => {},
                       'ListenSpecial' => {},
                       'ListenNetlink' => {},
                       'ListenMessageQueue' => {},
                       'BindIPv6Only' => {
                         kind_of: String, equal_to: %w( default both ipv6-only )
                       },
                       'Backlog' => { kind_of: Integer },
                       'BindToDevice' => {},
                       'SocketUser' => {},
                       'SocketGroup' => {},
                       'SocketMode' => { kind_of: [String, Integer] },
                       'DirectoryMode' => { kind_of: [String, Integer] },
                       'Accept' => { kind_of: [TrueClass, FalseClass] },
                       'MaxConnections' => { kind_of: Integer },
                       'KeepAlive' => { kind_of: [TrueClass, FalseClass] },
                       'KeepAliveTimeSec' => { kind_of: Integer },
                       'KeepAliveIntervalSec' => { kind_of: Integer },
                       'KeepAliveProbes' => { kind_of: Integer },
                       'NoDelay' => { kind_of: [TrueClass, FalseClass] },
                       'Priority' => { kind_of: Integer },
                       'DeferAcceptSec' => { kind_of: Integer },
                       'ReceiveBuffer' => { kind_of: Integer },
                       'SendBuffer' => { kind_of: Integer },
                       'IPTOS' => { kind_of: Integer },
                       'IPTTL' => { kind_of: Integer },
                       'Mark' => { kind_of: Integer },
                       'ReusePort' => { kind_of: [TrueClass, FalseClass] },
                       'SmackLabel' => {},
                       'SmackLabelIPIn' => {},
                       'SmackLabelIPOut' => {},
                       'SELinuxContextFromNet' => {
                         kind_of: [TrueClass, FalseClass]
                       },
                       'PipeSize' => { kind_of: [String, Integer] },
                       'MessageQueueMaxMessages' => { kind_of: Integer },
                       'MessageQueueMessageSize' => { kind_of: Integer },
                       'FreeBind' => { kind_of: [TrueClass, FalseClass] },
                       'Transparent' => { kind_of: [TrueClass, FalseClass] },
                       'Broadcast' => { kind_of: [TrueClass, FalseClass] },
                       'PassCredentials' => {
                         kind_of: [TrueClass, FalseClass]
                       },
                       'PassSecurity' => { kind_of: [TrueClass, FalseClass] },
                       'TCPCongestion' => {},
                       'ExecStartPre' => {},
                       'ExecStartPost' => {},
                       'ExecStopPre' => {},
                       'ExecStopPost' => {},
                       'TimeoutSec' => { kind_of: [String, Integer] },
                       'Service' => {},
                       'RemoveOnStop' => { kind_of: [TrueClass, FalseClass] },
                       'Symlinks' => { kind_of: [String, Array] })
  end

  module Swap
    OPTIONS ||= Systemd::ResourceControl::OPTIONS
                .merge(Systemd::Exec::OPTIONS)
                .merge(Systemd::Kill::OPTIONS)
                .merge('What' => { kind_of: String, required: true },
                       'Priority' => { kind_of: Integer },
                       'Options' => {},
                       'TimeoutSec' => { kind_of: [String, Integer] })
  end

  module System
    OPTIONS ||= {
      'LogLevel' => {},
      'LogTarget' => {},
      'LogColor' => {},
      'LogLocation' => {},
      'DumpCore' => {},
      'CrashShell' => {},
      'ShowStatus' => {},
      'CrashChVT' => {},
      'DefaultStandardOutput' => {},
      'DefaultStandardError' => {},
      'CPUAffinity' => { kind_of: [String, Array] },
      'JoinControllers' => { kind_of: [String, Array] },
      'RuntimeWatchdogSec' => { kind_of: [String, Integer] },
      'ShutdownWatchdogSec' => { kind_of: [String, Integer] },
      'CapabilityBoundingSet' => { kind_of: [String, Array] },
      'SystemCallArchitectures' => {
        kind_of: [String, Array],
        equal_to: %w( x86 x86-64 x32 arm native )
      },
      'TimerSlackNSec' => { kind_of: [String, Integer] },
      'DefaultTimerAccuracySec' => { kind_of: [String, Integer] },
      'DefaultTimeoutStartSec' => { kind_of: [String, Integer] },
      'DefaultTimeoutStopSec' => { kind_of: [String, Integer] },
      'DefaultRestartSec' => { kind_of: [String, Integer] },
      'DefaultStartLimitInterval' => { kind_of: [String, Integer] },
      'DefaultStartLimitBurst' => { kind_of: [String, Integer] },
      'DefaultEnvironment' => { kind_of: Hash },
      'DefaultCPUAccounting' => { kind_of: [TrueClass, FalseClass] },
      'DefaultBlockIOAccounting' => { kind_of: [TrueClass, FalseClass] },
      'DefaultMemoryAccounting' => { kind_of: [TrueClass, FalseClass] },
      'DefaultLimitCPU' => {},
      'DefaultLimitFSIZE' => {},
      'DefaultLimitDATA' => {},
      'DefaultLimitSTACK' => {},
      'DefaultLimitCORE' => {},
      'DefaultLimitRSS' => {},
      'DefaultLimitNOFILE' => {},
      'DefaultLimitAS' => {},
      'DefaultLimitNPROC' => {},
      'DefaultLimitMEMLOCK' => {},
      'DefaultLimitLOCKS' => {},
      'DefaultLimitSIGPENDING' => {},
      'DefaultLimitMSGQUEUE' => {},
      'DefaultLimitNICE' => {},
      'DefaultLimitRTPRIO' => {},
      'DefaultLimitRTTIME' => {}
    }
  end

  module Path
    OPTIONS ||= {
      'PathExists' => {},
      'PathExistsGlob' => {},
      'PathChanged' => {},
      'PathModified' => {},
      'DirectoryNotEmpty' => {},
      'Unit' => {
        kind_of: String,
        callbacks: {
          'is a valid unit ' => lambda do |spec|
            !spec.match(/\.path$/) &&
            (Systemd::Helpers::UNITS | Systemd::Helpers::STUB_UNITS).any? do |u|
              spec.match(/\.#{u}$/)
            end
          end
        }
      },
      'MakeDirectory' => { kind_of: [TrueClass, FalseClass] },
      'DirectoryMode' => { kind_of: [String, Integer] }
    }
  end

  module Target
    OPTIONS ||= {}
  end

  module Timer
    OPTIONS ||= {
      'OnActiveSec' => { kind_of: [String, Integer] },
      'OnBootSec' => { kind_of: [String, Integer] },
      'OnStartupSec' => { kind_of: [String, Integer] },
      'OnUnitActiveSec' => { kind_of: [String, Integer] },
      'OnUnitInactiveSec' => { kind_of: [String, Integer] },
      'OnCalendar' => {},
      'AccuracySec' => { kind_of: [String, Integer] },
      'Unit' => {
        kind_of: String,
        callbacks: {
          'is a valid unit ' => lambda do |spec|
            !spec.match(/\.timer$/) &&
            (Systemd::Helpers::UNITS | Systemd::Helpers::STUB_UNITS).any? do |u|
              spec.match(/\.#{u}$/)
            end
          end
        }
      },
      'Persistent' => { kind_of: [TrueClass, FalseClass] },
      'WakeSystem' => { kind_of: [TrueClass, FalseClass] }
    }
  end

  module Timesyncd
    OPTIONS ||= {
      'NTP' => { kind_of: [String, Array] },
      'FallbackNTP' => { kind_of: [String, Array] }
    }
  end

  # rubocop: disable ModuleLength
  module Unit
    UNIT_LIST ||= {
      kind_of: [String, Array],
      callbacks: {
        'is a valid unit ' => lambda do |spec|
          Array(spec).all? do |unit|
            (Systemd::Helpers::UNITS | Systemd::Helpers::STUB_UNITS).any? do |u| # rubocop: disable LineLength
              unit.match(/\.#{u}$/)
            end
          end
        end
      }
    }

    OPTIONS ||= {
      'Description' => {},
      'Documentation' => { kind_of: [String, Array] },
      'Requires' => UNIT_LIST,
      'RequiresOverridable' => UNIT_LIST,
      'Requisite' => UNIT_LIST,
      'RequisiteOverridable' => UNIT_LIST,
      'Wants' => UNIT_LIST,
      'BindsTo' => UNIT_LIST,
      'PartOf' => UNIT_LIST,
      'Conflicts' => UNIT_LIST,
      'Before' => UNIT_LIST,
      'After' => UNIT_LIST,
      'OnFailure' => UNIT_LIST,
      'PropagatesReloadTo' => UNIT_LIST,
      'ReloadPropagatedFrom' => UNIT_LIST,
      'JoinsNamespaceOf' => UNIT_LIST,
      'RequiresMountsFor' => { kind_of: [String, Array] },
      'OnFailureJobMode' => {
        kind_of: String,
        equal_to: %w(
          fail replace replace-irreversibly isolate
          flush ignore-dependencies ignore-requirements
        )
      },
      'IgnoreOnIsolate' => { kind_of: [TrueClass, FalseClass] },
      'IgnoreOnSnapshot' => { kind_of: [TrueClass, FalseClass] },
      'StopWhenUnneeded' => { kind_of: [TrueClass, FalseClass] },
      'RefuseManualStart' => { kind_of: [TrueClass, FalseClass] },
      'RefuseManualStop' => { kind_of: [TrueClass, FalseClass] },
      'AllowIsolate' => { kind_of: [TrueClass, FalseClass] },
      'DefaultDependencies' => { kind_of: [TrueClass, FalseClass] },
      'JobTimeoutSec' => { kind_of: [String, Integer] },
      'JobTimeoutAction' => {
        kind_of: String,
        equal_to: %w(
          none reboot reboot-force reboot-immediate
          poweroff poweroff-force poweroff-immediate
        )
      },
      'JobTimeoutRebootArgument' => {},
      'ConditionArchitecture' => {
        kind_of: String,
        equal_to: %w(
          x86 x86-64 ppc ppc-le ppc64 ppc64-le ia64 parisc parisc64
          s390 s390x sparc sparc64 mips mips-le mips64 mips64-le
          alpha arm arm-be arm64 arm64-be sh sh64 m86k tilegx cris
        )
      },
      'ConditionVirtualization' => {
        kind_of: [TrueClass, FalseClass, String],
        equal_to: [
          true, false, 'vm', 'container', 'qemu', 'kvm', 'zvm',
          'vmware', 'microsoft', 'oracle', 'xen', 'bochs', 'uml',
          'openvz', 'lxc', 'lxc-libvirt', 'systemd-nspawn', 'docker'
        ]
      },
      'ConditionHost' => {},
      'ConditionKernelCommandLine' => {},
      'ConditionSecurity' => {
        kind_of: String,
        equal_to: %w( selinux apparmor ima smack audit )
      },
      'ConditionCapability' => {},
      'ConditionACPower' => { kind_of: [TrueClass, FalseClass] },
      'ConditionNeedsUpdate' => {
        kind_of: String,
        equal_to: %w( /var /etc !/var !/etc )
      },
      'ConditionFirstBoot' => { kind_of: [TrueClass, FalseClass] },
      'ConditionPathExists' => {},
      'ConditionPathExistsGlob' => {},
      'ConditionPathIsDirectory' => {},
      'ConditionPathIsSymbolicLink' => {},
      'ConditionPathIsMountPoint' => {},
      'ConditionPathIsReadWrite' => {},
      'ConditionDirectoryNotEmpty' => {},
      'ConditionFileNotEmpty' => {},
      'ConditionFileIsExecutable' => {},
      'AssertArchitecture' => {
        kind_of: String,
        equal_to: %w(
          x86 x86-64 ppc ppc-le ppc64 ppc64-le ia64 parisc parisc64
          s390 s390x sparc sparc64 mips mips-le mips64 mips64-le
          alpha arm arm-be arm64 arm64-be sh sh64 m86k tilegx cris
        )
      },
      'AssertVirtualization' => {
        kind_of: [TrueClass, FalseClass, String],
        equal_to: [
          true, false, 'qemu', 'kvm', 'zvm', 'vmware',
          'microsoft', 'oracle', 'xen', 'bochs', 'openvz',
          'lxc', 'lxc-libvirt', 'systemd-nspawn', 'docker', 'uml'
        ]
      },
      'AssertHost' => {},
      'AssertKernelCommandLine' => {},
      'AssertSecurity' => {
        kind_of: String,
        equal_to: %w( selinux apparmor ima smack audit )
      },
      'AssertCapability' => {},
      'AssertACPower' => { kind_of: [TrueClass, FalseClass] },
      'AssertNeedsUpdate' => {
        kind_of: String,
        equal_to: %w( /var /etc !/var !/etc )
      },
      'AssertFirstBoot' => {},
      'AssertPathExists' => {},
      'AssertPathExistsGlob' => {},
      'AssertPathIsDirectory' => {},
      'AssertPathIsSymbolicLink' => {},
      'AssertPathIsMountPoint' => {},
      'AssertPathIsReadWrite' => {},
      'AssertDirectoryNotEmpty' => {},
      'AssertFileNotEmpty' => {},
      'AssertFileIsExecutable' => {},
      'SourcePath' => {}
    }
  end
  # rubocop: enable ModuleLength

  module User
    OPTIONS ||= Systemd::System::OPTIONS
  end

  module Vconsole
    OPTIONS ||= {
      'KEYMAP' => {},
      'KEYMAP_TOGGLE' => {},
      'FONT' => {},
      'FONT_MAP' => {},
      'FONT_UNIMAP' => {}
    }
  end
end
