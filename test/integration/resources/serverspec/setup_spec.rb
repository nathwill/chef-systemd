require 'spec_helper'

describe 'setup::default' do
  # Test the service resource
  describe file('/etc/systemd/system/test-unit.service') do
    it { should be_file }
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=Test Service/ }
    its(:content) { should match /Documentation=man:true\(1\)/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /Alias=testing-unit.service testd.service/ }
    its(:content) { should match /WantedBy=multi-user.target/ }
    its(:content) { should match /\[Service\]/ }
    its(:content) { should match /MemoryLimit=5M/ }
    its(:content) { should match /User=nobody/ }
    its(:content) { should match /KillSignal=SIGTERM/ }
    its(:content) { should match /Type=oneshot/ }
    its(:content) { should match /ExecStart=\/usr\/bin\/true/ }
  end

  # Test drop-in mode
  describe file('/etc/systemd/system/sshd.service.d/my-override.conf') do
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=$/ }
    its(:content) { should match /Description=Test Override/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /Alias=$/ }
    its(:content) { should match /Alias=ssh.service openssh.service/ }
    its(:content) { should match /\[Service\]/ }
    its(:content) { should match /CPUQuota=10%/ }
  end

  # Test the socket resource
  describe file('/etc/systemd/system/sshd.socket') do
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=SSH Socket for Per-Connection Servers/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /WantedBy=sockets.target/ }
    its(:content) { should match /\[Socket\]/ }
    its(:content) { should match /CPUQuota=20%/ }
    its(:content) { should match /ProtectSystem=full/ }
    its(:content) { should match /KillMode=control-group/ }
    its(:content) { should match /ListenStream=22/ }
    its(:content) { should match /Accept=yes/ }
  end

  # Test the device resource
  describe file('/etc/systemd/system/vdb.device') do
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=Test Device/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /WantedBy=multi-user.target/ }
  end

  # Test the mount resource
  describe file('/etc/systemd/system/tmp-mount.mount') do
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=Test Mount/ }
    its(:content) { should match /Documentation=man:hier\(7\)/ }
    its(:content) { should match /Conflicts=umount.target/ }
    its(:content) { should match /Before=local-fs.target umount.target/ }
    its(:content) { should match /DefaultDependencies=no/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /WantedBy=local-fs.target/ }
    its(:content) { should match /\[Mount\]/ }
    its(:content) { should match /Slice=system.slice/ }
    its(:content) { should match /IOSchedulingPriority=0/ }
    its(:content) { should match /KillMode=mixed/ }
    its(:content) { should match /What=tmpfs/ }
    its(:content) { should match /Where=\/tmp/ }
    its(:content) { should match /Type=tmpfs/ }
    its(:content) { should match /Options=mode=1777,strictatime/ }
    its(:content) { should match /TimeoutSec=300/ }
  end

  # Test the automount resource
  describe file('/etc/systemd/system/vagrant-home.automount') do
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=Test Automount/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /WantedBy=local-fs.target/ }
    its(:content) { should match /\[Automount\]/ }
    its(:content) { should match /Where=\/home\/vagrant/ }
  end

  # Test the swap resource
  describe file('/etc/systemd/system/swap.swap') do
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=Test Swap/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /WantedBy=local-fs.target/ }
    its(:content) { should match /\[Swap\]/ }
    its(:content) { should match /BlockIOAccounting=true/ }
    its(:content) { should match /Personality=x86/ }
    its(:content) { should match /SendSIGHUP=no/ }
    its(:content) { should match /What=\/dev\/swap/ }
    its(:content) { should match /TimeoutSec=5/ }
  end

  # Test the target resource
  describe file('/etc/systemd/system/test.target') do
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=Test Target/ }
    its(:content) { should match /Documentation=man:systemd.special\(7\)/ }
    its(:content) { should match /StopWhenUnneeded=yes/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /Alias=tested.target/ }
  end

  # Test the path resource
  describe file('/etc/systemd/system/dummy.path') do
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=Test Path/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /WantedBy=multi-user.target/ }
    its(:content) { should match /\[Path\]/ }
    its(:content) { should match /DirectoryNotEmpty=\/var\/run\/queue/ }
    its(:content) { should match /Unit=queue-worker.service/ }
    its(:content) { should match /MakeDirectory=true/ }
  end

  # Test the timer resource
  describe file('/etc/systemd/system/clean-tmp.timer') do
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=Test Timer/ }
    its(:content) { should match /Documentation=man:tmpfiles.d\(5\) man:systemd-tmpfiles\(8\)/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /WantedBy=multi-user.target/ }
    its(:content) { should match /\[Timer\]/ }
    its(:content) { should match /OnBootSec=15min/ }
    its(:content) { should match /OnUnitActiveSec=1d/ }
  end

  # Test the slice resource
  describe file('/etc/systemd/system/customer-1.slice') do
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Description=Test Slice/ }
    its(:content) { should match /\[Install\]/ }
    its(:content) { should match /WantedBy=multi-user.target/ }
    its(:content) { should match /\[Slice\]/ }
    its(:content) { should match /CPUShares=1024/ }
    its(:content) { should match /MemoryLimit=1G/ }
  end

  describe service('rsyslog') do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe file('/etc/systemd/network/wireless0.link') do
    it { should be_file }
    its(:content) { should match %r{[Match]} }
    its(:content) { should match /Path=pci-0000:02:00.0-*/ }
    its(:content) { should match /Driver=brcmsmac/ }
    its(:content) { should match /Type=wlan/ }
    its(:content) { should match /Host=my-laptop/ }
    its(:content) { should match /Virtualization=no/ }
    its(:content) { should match /Architecture=x86-64/ }
    its(:content) { should match /MACAddress=12:34:56:78:9a:bc/ }
    its(:content) { should match %r{[Link]} }
    its(:content) { should match /Name=wireless0/ }
    its(:content) { should match /MTUBytes=1450/ }
    its(:content) { should match /BitsPerSecond=10M/ }
    its(:content) { should match /WakeOnLan=magic/ }
    its(:content) { should match /MACAddress=cb:a9:87:65:43:21/ }
  end
end
