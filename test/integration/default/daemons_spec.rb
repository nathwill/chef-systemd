control 'creates journald drop-ins' do
  describe file('/etc/systemd/journald.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Journal]
Compress = yes
SystemKeepFree = 1G
ForwardToSyslog = yes
EOT
    end
  end
end

control 'creates logind drop-ins' do
  describe file('/etc/systemd/logind.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Login]
KillUserProcesses = yes
KillOnlyUsers = vagrant
EOT
    end
  end
end

control 'creates resolved drop-ins' do
  describe file('/etc/systemd/resolved.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Resolve]
DNS = 208.67.222.222 208.67.220.220
FallbackDNS = 8.8.8.8 8.8.4.4
EOT
    end
  end
end

control 'creates timesyncd drop-ins' do
  case os[:name]
  when 'fedora'
    describe file('/etc/systemd/timesyncd.conf.d/my-overrides.conf') do
      its(:content) do
        should eq <<EOT
[Time]
NTP = 0.fedora.pool.ntp.org 1.fedora.pool.ntp.org 2.fedora.pool.ntp.org 3.fedora.pool.ntp.org
FallbackNTP = 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
EOT
      end
    end
  when 'debian'
    describe file('/etc/systemd/timesyncd.conf.d/my-overrides.conf') do
      its(:content) do
        should eq <<EOT
[Time]
NTP = 0.debian.pool.ntp.org 1.debian.pool.ntp.org 2.debian.pool.ntp.org 3.debian.pool.ntp.org
FallbackNTP = 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
EOT
      end
    end
  when 'ubuntu'
    describe file('/etc/systemd/timesyncd.conf.d/my-overrides.conf') do
      its(:content) do
        should eq <<EOT
[Time]
NTP = 0.ubuntu.pool.ntp.org 1.ubuntu.pool.ntp.org 2.ubuntu.pool.ntp.org 3.ubuntu.pool.ntp.org
FallbackNTP = 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org
EOT
      end
    end
  end
end

control 'creates coredump drop-in' do
  describe file('/etc/systemd/coredump.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Coredump]
Storage = external
Compress = yes
EOT
    end
  end
end

control 'creates sleep drop-in' do
  describe file('/etc/systemd/sleep.conf.d/my-overrides.conf') do
    its(:content) do
      should eq <<EOT
[Sleep]
SuspendState = freeze
EOT
    end
  end
end

control 'creates journal-upload drop-in' do
  describe file('/etc/systemd/journal-upload.conf.d/my-override.conf') do
    its(:content) do
      should eq <<EOT
[Upload]
URL = http://127.0.0.1
EOT
    end
  end
end

control 'creates journal-remote drop-in' do
  describe file('/etc/systemd/journal-remote.conf.d/my-override.conf') do
    its(:content) do
      should eq <<EOT
[Remote]
Seal = yes
SplitMode = host
EOT
    end
  end
end
