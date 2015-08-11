require 'spec_helper'

describe Chef::Resource::SystemdNetworkdLink do
  let(:link) do
    l = Chef::Resource::SystemdNetworkdLink.new('link')
    l.match_mac_addr '12:34:56:78:9a:bc'
    l.driver 'brcmsmac'
    l.path 'pci-0000:02:00.0-*'
    l.type 'wlan'
    l.virtualization 'no'
    l.host 'my-laptop'
    l.architecture 'x86-64'
    l.name 'wireless0'
    l.mtu_bytes '1450'
    l.bits_per_second '10M'
    l.wake_on_lan 'magic'
    l.link_mac_addr 'cb:a9:87:65:43:21'
    l
  end

  let(:hash) do
    {
      :match => [
        "Path=pci-0000:02:00.0-*",
        "Driver=brcmsmac",
        "Type=wlan",
        "Host=my-laptop",
        "Virtualization=no",
        "Architecture=x86-64",
        "MACAddress=12:34:56:78:9a:bc"
      ],
      :link => [
        "Name=wireless0",
        "MTUBytes=1450",
        "BitsPerSecond=10M",
        "WakeOnLan=magic",
        "MACAddress=cb:a9:87:65:43:21"
      ]
    }
  end

  it 'produces a correct hash' do
    expect(link.to_hash).to eq hash
  end
end
