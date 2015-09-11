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
      'CPUAffinity' => {},
      'JoinControllers' => {},
      'RuntimeWatchdogSec' => {},
      'ShutdownWatchdogSec' => {},
      'CapabilityBoundingSet' => {},
      'SystemCallArchitectures' => {},
      'TimerSlackNSec' => {},
      'DefaultTimerAccuracySec' => {},
      'DefaultTimeoutStartSec' => {},
      'DefaultTimeoutStopSec' => {},
      'DefaultRestartSec' => {},
      'DefaultStartLimitInterval' => {},
      'DefaultStartLimitBurst' => {},
      'DefaultEnvironment' => {},
      'DefaultCPUAccounting' => {},
      'DefaultBlockIOAccounting' => {},
      'DefaultMemoryAccounting' => {},
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
