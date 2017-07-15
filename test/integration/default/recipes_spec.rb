control 'sets the hostname' do
  describe file('/etc/hostname') do
    its(:content) { should match /my-hostname/ }
  end

  describe command('hostname') do
    its(:stdout) { should match /my-hostname/ }
  end
end

control 'manages journald' do
  describe service('systemd-journald') do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'manages localed' do
  describe file('/etc/locale.conf') do
    its(:content) { should eq 'LANG=en_US.UTF-8' }
  end

  describe command('localectl status') do
    its(:stdout) { should match %r{System Locale: LANG=en_US.UTF-8} }
  end
end

control 'manages networkd' do
  unless os.redhat?
    describe service('systemd-networkd') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

control 'manages rtc' do
  describe command('timedatectl status') do
    its(:stdout) { should match /RTC in local TZ: no/ }
  end
end

control 'manages timesyncd' do
  # Ubuntu explicitly blocks service in VirtualBox...
  unless os.debian? || os.redhat?
    describe service('systemd-timesyncd') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end

control 'manages timezone' do
  describe command('timedatectl status') do
    its(:stdout) { should match /Time zone: (Etc\/)?UTC/ }
  end
end

control 'manages vconsole' do
  unless os.debian?
    describe file('/etc/vconsole.conf') do
      its(:content) do
        should eq <<EOT.chomp
KEYMAP=us
FONT=latarcyrheb-sun16
EOT
      end
    end

    describe command('localectl status') do
      its(:stdout) { should match /VC Keymap: us/ }
    end
  end
end
