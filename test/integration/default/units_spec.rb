control 'creates automount units' do
  describe file('/etc/systemd/system/proc-sys-fs-binfmt_misc.automount') do
    its(:content) do
      should eq <<EOT
[Automount]
Where = /proc/sys/fs/binfmt_misc

[Unit]
Before = sysinit.target
DefaultDependencies = no
ConditionPathExists = /proc/sys/fs/binfmt_misc/
ConditionPathIsReadWrite = /proc/sys/
EOT
    end
  end
end

control 'creates mount units' do
  describe file('/etc/systemd/system/tmp.mount') do
    its(:content) do
      should eq <<EOT
[Mount]
What = tmpfs
Where = /tmp
Type = tmpfs
Options = mode=1777,strictatime

[Unit]
Description = temp dir
Documentation = man:hier(7)
Conflicts = umount.target
Before = local-fs.target umount.target
DefaultDependencies = no
ConditionPathIsSymbolicLink = !/tmp
EOT
    end
  end
end

control 'creates service units' do
  describe file('/etc/systemd/system/systemd-ask-password-console.service') do
    its(:content) do
      should eq <<EOT
[Service]
ExecStart = /usr/bin/systemd-tty-ask-password-agent --wall
ExecStartPre = -/usr/bin/systemctl stop systemd-ask-password-console.path systemd-ask-password-console.service systemd-ask-password-plymouth.path systemd-ask-password-plymouth.service
User = root

[Unit]
Description = forward password reqs to wall
Documentation = man:systemd-ask-password-console.service(8)
After = systemd-user-session.service
EOT
    end
  end
end

control 'creates path units' do
  describe file('/etc/systemd/system/systemd-ask-password-console.path') do
    its(:content) do
      should eq <<EOT
[Path]
DirectoryNotEmpty = /run/systemd/ask-password
MakeDirectory = yes

[Unit]
Description = forward password reqs to wall
Documentation = man:systemd-ask-password-console.service(8)
Conflicts = shutdown.target
Before = paths.target shutdown.target
DefaultDependencies = no
EOT
    end
  end
end

control 'creates slice units' do
  describe file('/etc/systemd/system/user.slice') do
    its(:content) do
      should eq <<EOT
[Slice]
MemoryLimit = 512M

[Unit]
Before = slices.target
EOT
    end
  end
end

control 'creates socket units' do
  describe file('/etc/systemd/system/systemd-journald.socket') do
    its(:content) do
      should eq <<EOT
[Socket]
ListenStream = /run/systemd/journal/stdout
ListenDatagram = /run/systemd/journal/socket
SocketMode = 0666
ReceiveBuffer = 8M
PassCredentials = yes
PassSecurity = yes
Service = systemd-journald.service

[Unit]
Description = journal socket
Before = sockets.target
IgnoreOnIsolate = yes
DefaultDependencies = no
EOT
    end
  end
end

control 'creates swap units' do
  describe file('/etc/systemd/system/dev-mapper-swap.swap') do
    its(:content) do
      should eq <<EOT
[Swap]
What = /dev/mapper/swap
TimeoutSec = 60
EOT
    end
  end
end

control 'creates target units' do
  describe file('/etc/systemd/system/my-app.target') do
    its(:content) do
      should eq <<EOT
[Unit]
Description = my cool app
After = network-online.target

[Install]
WantedBy = multi-user.target
EOT
    end
  end
end

control 'creates timer units' do
  describe file('/etc/systemd/system/systemd-tmpfiles-clean.timer') do
    its(:content) do
      should eq <<EOT
[Timer]
OnBootSec = 15m
OnUnitActiveSec = 1d

[Unit]
Description = clean tmpfiles
EOT
    end
  end
end
