# http://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
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
end
