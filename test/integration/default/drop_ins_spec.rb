control 'creates automount drop-ins' do
  describe file('/etc/systemd/system/proc-sys-fs-binfmt_misc.automount.d/proc-sys-fs-binfmt_misc-override.conf') do
    its(:content) do
      should eq <<EOT
[Automount]
TimeoutIdleSec = 90min
EOT
    end
  end
end

control 'creates mount drop-ins' do
  describe file('/etc/systemd/system/tmp.mount.d/tmp-override.conf') do
    its(:content) do
      should eq <<EOT
[Mount]
SloppyOptions = yes
EOT
    end
  end
end

control 'creates path drop-ins' do
  describe file('/etc/systemd/system/systemd-ask-password-console.path.d/systemd-ask-password-console-override.conf') do
    its(:content) do
      should eq <<EOT
[Path]
DirectoryMode = 0755
EOT
    end
  end
end

control 'creates service drop-ins' do
  describe file('/etc/systemd/system/systemd-ask-password-console.service.d/systemd-ask-password-console.conf') do
    its(:content) do
      should eq <<EOT
[Service]
ExecStart = 
ExecStart = /usr/bin/systemd-tty-ask-password-agent --watch --console
EOT
    end
  end
end

control 'supports user drop-ins' do
  if os[:name] == 'fedora'
    describe file('/etc/systemd/user/dummy.service.d/user-service-drop-in.conf') do
      its(:content) do
        should eq <<EOT
[Unit]
Description = user-mode drop-in
EOT
      end
    end
  end
end

control 'creates slice drop-ins' do
  describe file('/etc/systemd/system/user.slice.d/user-memory-limit-local.conf') do
    its(:content) do
      should eq <<EOT
[Slice]
MemoryLimit = 256G
EOT
    end
  end
end

control 'creates socket drop-ins' do
  describe file('/etc/systemd/system/systemd-journald.socket.d/systemd-journald.conf') do
    its(:content) do
      should eq <<EOT
[Socket]
ReceiveBuffer = 16M
EOT
    end
  end
end

control 'creates swap drop-ins' do
  describe file('/etc/systemd/system/dev-mapper-swap.swap.d/dev-mapper-swap.conf') do
    its(:content) do
      should eq <<EOT
[Swap]
TimeoutSec = 120
EOT
    end
  end
end

control 'creates target drop-ins' do
  describe file('/etc/systemd/system/my-app.target.d/my-app-local.conf') do
    its(:content) do
      should eq <<EOT
[Unit]
Description = my really cool app
EOT
    end
  end
end

control 'creates timer drop-in' do
  describe file('/etc/systemd/system/systemd-tmpfiles-clean.timer.d/systemd-tmpfiles-clean.conf') do
    its(:content) do
      should eq <<EOT
[Timer]
OnUnitActiveSec = 1h
EOT
    end
  end
end
