require 'spec_helper'

describe 'Systemd Resources' do
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
    its(:content) { should match /Nice=-5/ }
    its(:content) { should match /ExecStart=\/usr\/bin\/true/ }
  end

  # set_properties action test
  describe file('/etc/systemd/system/postfix.service.d/postfix-cpu-tuning.conf') do
    it { should be_file }
    its(:content) { should match /CPUShares=1200/ }
    its(:content) { should match /CPUAccounting=yes/ }
  end

  describe file('/etc/systemd/system/postfix.service.d/90-CPUShares.conf') do
    it { should_not be_file }
  end

  describe file('/etc/systemd/system/postfix.service.d/90-CPUAccounting.conf') do
    it { should_not be_file }
  end

  describe command('systemctl show postfix.service -p CPUShares -p CPUAccounting') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /CPUShares=1200/ }
    its(:stdout) { should match /CPUAccounting=yes/ }
  end

  # Test masking
  describe command("systemctl is-enabled vsftpd.service") do
    its(:stdout) { should match /masked/ }
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
    its(:content) { should match %r{Environment="MY_ENV=IS AWESOME"} }
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
    its(:content) { should match /BlockIOAccounting=yes/ }
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

  # Test the limit resource
  describe file('/etc/systemd/system/vsftpd.service.d/limits.conf') do
    its(:content) { should match /\[Service\]/ }
    its(:content) { should match /LimitNOFILE=10240/ }
  end

  describe command('systemctl get-default') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /test.target/ }
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
    its(:content) { should match /MakeDirectory=yes/ }
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

  # Test lifecycle actions
  describe service('rsyslog') do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  # Test the networkd_link resource
  describe file('/etc/systemd/network/wireless0.link') do
    it { should be_file }
    its(:content) { should match %r{[Match]} }
    its(:content) { should match /Path=pci-0000:02:00.0-*/ }
    its(:content) { should match /Driver=brcmsmac/ }
    its(:content) { should match /Type=wlan/ }
    its(:content) { should match /Host=my-laptop/ }
    its(:content) { should match /Virtualization=false/ }
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
