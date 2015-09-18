# http://www.freedesktop.org/software/systemd/man/systemd-system.conf.html
#
# Cookbook Name:: systemd
# Module:: Systemd::System
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
end
