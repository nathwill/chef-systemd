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
    OPTIONS ||= %w(
      CPUAccounting
      CPUShares
      StartupCPUShares
      CPUQuota
      MemoryAccounting
      MemoryLimit
      BlockIOAccounting
      BlockIOWeight
      StartupBlockIOWeight
      BlockIODeviceWeight
      BlockIOReadBandwidth
      BlockIOWriteBandwidth
      DeviceAllow
      DevicePolicy
      Slice
      Delegate
    )
  end

  def cpu_accounting(arg = nil)
    set_or_return(
      :cpu_accounting, arg,
      kind_of: [TrueClass, FalseClass]
    )
  end

  def cpu_shares(arg = nil)
    set_or_return(
      :cpu_shares, arg,
      kind_of: Integer
    )
  end

  def startup_cpu_shares(arg = nil)
    set_or_return(
      :startup_cpu_shares, arg,
      kind_of: Integer
    )
  end

  def memory_accounting(arg = nil)
    set_or_return(
      :memory_accounting, arg,
      kind_of: [TrueClass, FalseClass]
    )
  end

  def block_io_accounting(arg = nil)
    set_or_return(
      :block_io_accounting, arg,
      kind_of: [TrueClass, FalseClass]
    )
  end

  def block_io_weight(arg = nil)
    set_or_return(
      :block_io_weight, arg,
      kind_of: Integer,
      equal_to: 10.upto(1_000)
    )
  end

  def startup_block_io_weight(arg = nil)
    set_or_return(
      :startup_block_io_weight, arg,
      kind_of: Integer,
      equal_to: 10.upto(1_000)
    )
  end

  def device_policy(arg = nil)
    set_or_return(
      :device_policy, arg,
      kind_of: String,
      equal_to: %w( strict closed auto )
    )
  end

  def delegate(arg = nil)
    set_or_return(
      :delegate, arg,
      kind_of: [TrueClass, FalseClass]
    )
  end
end
