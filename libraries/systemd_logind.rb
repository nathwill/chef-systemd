# http://www.freedesktop.org/software/systemd/man/logind.conf.html
#
# Cookbook Name:: systemd
# Module:: Systemd::Logind
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
end
