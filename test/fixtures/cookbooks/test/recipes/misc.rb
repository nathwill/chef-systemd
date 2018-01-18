systemd_bootchart 'my-overrides' do
  bootchart do
    scale_x 100
    scale_y 20
  end
end

systemd_system 'my-overrides' do
  manager do
    default_environment({ 'ENVIRONMENT' => 'production' })
    default_timeout_start_sec 30
  end
end

systemd_user 'my-overrides' do
  manager do
    default_environment({ 'ENVIRONMENT' => 'production' })
    default_timeout_start_sec 120
  end
end

systemd_binfmt 'DOSWin' do
  magic 'MZ'
  interpreter '/usr/bin/wine'
end

systemd_modules 'die-beep-die' do
  blacklist true
  modules %w( pcspkr )
  action [:create, :unload]
end

# Test creating, loading
systemd_modules 'vboxguest' do
  modules %w( vboxguest )
  action [:create, :load]
end

systemd_sysctl 'vm.swappiness' do
  value 10
  action [:create, :apply]
end

systemd_sysuser '_testuser' do
  id 65_530
  gecos 'my test user'
  home '/var/lib/test'
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=823322
  only_if { platform?('fedora') }
end

systemd_tmpfile 'my-app' do
  path '/tmp/my-app'
  age '10d'
  type 'f'
end

# Fix up unworkably small default machines.raw in Debian
systemd_mount 'var-lib-machines' do
  action :stop
  only_if { platform?('debian') }
end

file '/var/lib/machines.raw' do
  action :delete
  only_if { platform?('debian') }
end

execute 'fallocate -l 2G /var/lib/machines.raw' do
  only_if { platform?('debian') }
end

execute 'mkfs.btrfs /var/lib/machines.raw' do
  only_if { platform?('debian') }
  notifies :start, 'systemd_mount[var-lib-machines]', :immediately
end

systemd_machine_image 'Fedora26' do
  type 'raw'
  source 'https://dl.fedoraproject.org/pub/fedora/linux/releases/26/CloudImages/x86_64/images/Fedora-Cloud-Base-26-1.5.x86_64.raw.xz'
  verify 'no'
  read_only false
  format 'gzip'
  path '/var/tmp/Fedora26.raw.gz'
  to 'cloned'
  action [:pull, :set_properties, :export, :clone]
  not_if { platform?('centos') }
end

systemd_machine_image 'Fedora26b' do
  type 'raw'
  verify 'no'
  read_only true
  format 'gzip'
  path '/var/tmp/Fedora26.raw.gz'
  action [:import, :set_properties]
  not_if { platform?('centos') }
end

systemd_nspawn 'Fedora26' do
  exec do
    boot true
    private_users false
  end
  files do
    bind '/tmp:/tmp'
  end
  network do
    private false
    virtual_ethernet false
  end
end

require 'tempfile'

tmp = Tempfile.new('Fedora26')
tmp_path = tmp.path
tmp.delete

systemd_machine 'Fedora26' do
  host_path tmp_path
  machine_path '/etc/passwd'
  action [:enable, :start, :copy_from]
  not_if { platform?('centos') }
end

systemd_netdev 'vlan1' do
  match do
    virtualization false
  end

  # cannot use sub-resource here, never reaches method_missing context handling
  net_dev_name 'vlan1'

  net_dev do
    kind 'vlan'
  end
  vlan do
    id 1
  end
end

systemd_link 'dmz' do
  match do
    mac_address '00:a0:de:63:7a:e6'
  end
  link_name 'dmz0'
end

systemd_network 'bond' do
  match_name 'bond1'
  network_dhcp true
end
