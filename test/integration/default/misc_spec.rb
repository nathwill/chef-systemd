control 'creates bootchart drop-ins' do
  describe file('/etc/systemd/bootchart.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Bootchart]
ScaleX = 100
ScaleY = 20
EOT
    end
  end
end

control 'creates system drop-ins' do
  describe file('/etc/systemd/system.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Manager]
DefaultTimeoutStartSec = 30
DefaultEnvironment = ENVIRONMENT=production
EOT
    end
  end
end

control 'creates user drop-ins' do
  describe file('/etc/systemd/user.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Manager]
DefaultTimeoutStartSec = 120
DefaultEnvironment = ENVIRONMENT=production
EOT
    end
  end
end

control 'creates binfmt configs' do
  describe file('/etc/binfmt.d/DOSWin.conf') do
    its(:content) { should eq ':DOSWin:M::MZ::/usr/bin/wine:' }
  end

  describe file('/proc/sys/fs/binfmt_misc/DOSWin') do
    its(:content) do
      should eq <<EOT
enabled
interpreter /usr/bin/wine
flags: 
offset 0
magic 4d5a
EOT
    end
  end
end

control 'creates modules' do
  describe file('/etc/modprobe.d/die-beep-die.conf') do
    its(:content) { should eq 'blacklist pcspkr' }
  end

  describe file('/etc/modules-load.d/vboxguest.conf') do
    its(:content) { should eq 'vboxguest' }
  end

  describe file('/proc/modules') do
    its(:content) { should_not match /^beep/ }
    its(:content) { should match /^vboxguest/ }
  end
end

control 'creates sysctls' do
  describe file('/etc/sysctl.d/vm.swappiness.conf') do
    its(:content) { should eq 'vm.swappiness=10' }
  end

  describe command('sysctl vm.swappiness') do
    its(:stdout) { should match /vm.swappiness = 10/ }
  end
end


control 'creates sysusers' do
  unless os.redhat? || os.debian?
    describe file('/etc/sysusers.d/_testuser.conf') do
      its(:content) { should eq 'u _testuser 65530 "my test user" /var/lib/test' }
    end

    describe user('_testuser') do
      it { should exist }
      its('uid') { should eq 65530 }
      its('home') { should eq '/var/lib/test' }
    end
  end
end

control 'creates tmpfiles' do
  unless os.debian?
    describe file('/etc/tmpfiles.d/my-app.conf') do
      its(:content) { should eq 'f /tmp/my-app - - - 10d -' }
    end

    describe file('/tmp/my-app') do
      it { should exist }
    end
  end
end

control 'creates nspawn units' do
  describe file('/etc/systemd/nspawn/Fedora26.nspawn') do
    its(:content) do
      should eq <<EOT
[Exec]
Boot = yes
PrivateUsers = no

[Files]
Bind = /tmp:/tmp

[Network]
Private = no
VirtualEthernet = no
EOT
    end
  end
end

control 'machine image' do
  unless os.redhat?
    describe command('machinectl list-images') do
      its(:stdout) { should match /Fedora26  raw  no/ }
      its(:stdout) { should match /Fedora26b raw  yes/ }
      its(:stdout) { should match /cloned    raw  no/ }
    end
  end
end

control 'machine' do
  unless os.redhat?
    describe command('machinectl list') do
      its(:stdout) { should match /Fedora26 container systemd-nspawn/ }
    end
  end
end

control 'netdev' do
  describe file('/etc/systemd/network/vlan1.netdev') do
    its(:content) do
      should eq <<EOT
[Match]
Virtualization = no

[NetDev]
Name = vlan1
Kind = vlan

[VLAN]
Id = 1
EOT
    end
  end
end

control 'network' do
  describe file('/etc/systemd/network/bond.network') do
    its(:content) do
      should eq <<EOT
[Match]
Name = bond1

[Network]
DHCP = yes
EOT
    end
  end
end

control 'link' do
  describe file('/etc/systemd/network/dmz.link') do
    its(:content) do
      should eq <<EOT
[Match]
MACAddress = 00:a0:de:63:7a:e6

[Link]
Name = dmz0
EOT
    end
  end
end
