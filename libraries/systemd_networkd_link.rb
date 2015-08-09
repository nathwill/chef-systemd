module Systemd::Networkd
  module Link
    OPTIONS ||= %w(
      Description
      Alias
      MACAddressPolicy
      MACAddress
      NamePolicy
      Name
      MTUBytes
      BitsPerSecond
      Duplex
      WakeOnLan
    )
  end
end
