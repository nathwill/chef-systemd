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
end
