
# Test the link resource
systemd_networkd_link 'wireless' do
  match do
    match_mac_addr '12:34:56:78:9a:bc'
    driver 'brcmsmac'
    path 'pci-0000:02:00.0-*'
    type 'wlan'
    virtualization 'no'
    host 'my-laptop'
    architecture 'x86-64'
  end

  link do
    name 'wireless0'
    mtu_bytes '1450'
    bits_per_second '10M'
    wake_on_lan 'magic'
    link_mac_addr 'cb:a9:87:65:43:21'
  end
end
