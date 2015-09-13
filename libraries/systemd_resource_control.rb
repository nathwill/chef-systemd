# http://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
#
# Cookbook Name:: systemd
# Module:: Systemd::ResourceControl
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
end
