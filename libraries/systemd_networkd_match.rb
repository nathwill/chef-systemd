module Systemd
  module Networkd
    module Match
      OPTIONS ||= %w(
        MACAddress
        OriginalName
        Path
        Driver
        Type
        Host
        Virtualization
        KernelCommandLine
        Architecture
      )
    end
  end
end
