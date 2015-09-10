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
  module Exec
    OPTIONS ||= {
      'WorkingDirectory' => {},
      'RootDirectory' => {},
      'User' => {},
      'Group' => {},
      'SupplementaryGroups' => {},
      'Nice' => {},
      'OOMScoreAdjust' => {},
      'IOSchedulingClass' => {},
      'IOSchedulingPriority' => {},
      'CPUSchedulingPolicy' => {},
      'CPUSchedulingPriority' => {},
      'CPUSchedulingResetOnFork' => {},
      'CPUAffinity' => {},
      'UMask' => {},
      'Environment' => {},
      'EnvironmentFile' => {},
      'StandardInput' => {},
      'StandardOutput' => {},
      'StandardError' => {},
      'TTYPath' => {},
      'TTYReset' => {},
      'TTYVHangup' => {},
      'TTYVTDisallocate' => {},
      'SyslogIdentifier' => {},
      'SyslogFacility' => {},
      'SyslogLevel' => {},
      'SyslogLevelPrefix' => {},
      'TimerSlackNSec' => {},
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
      'SecureBits' => {},
      'Capabilities' => {},
      'ReadWriteDirectories' => {},
      'ReadOnlyDirectories' => {},
      'InaccessibleDirectories' => {},
      'PrivateTmp' => {},
      'PrivateDevices' => {},
      'PrivateNetwork' => {},
      'ProtectSystem' => {},
      'ProtectHome' => {},
      'MountFlags' => {},
      'UtmpIdentifier' => {},
      'SELinuxContext' => {},
      'AppArmorProfile' => {},
      'SmackProcessLabel' => {},
      'IgnoreSIGPIPE' => {},
      'NoNewPrivileges' => {},
      'SystemCallFilter' => {},
      'SystemCallErrorNumber' => {},
      'SystemCallArchitectures' => {},
      'RestrictAddressFamilies' => {},
      'Personality' => {},
      'RuntimeDirectory' => {},
      'RuntimeDirectoryMode' => {}
    }
  end
end
