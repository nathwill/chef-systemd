require 'spec_helper'

describe 'JournalGatewayd' do
  describe 'installs the package' do
    describe package('systemd-journal-gateway') do
      it { should be_installed }
    end
  end

  describe 'overrides the listen_stream' do
    describe file('/etc/systemd/system/systemd-journal-gatewayd.socket.d/local-journal-gatewayd-listen-stream.conf') do
      it { should be_file }
      its(:content) { should match %r{[Socket]} }
      its(:content) { should match /^ListenStream=$/ }
      its(:content) { should match /ListenStream=19532/ }
    end

    describe command('systemctl show systemd-journal-gatewayd.socket | grep ListenStream') do
      its(:stdout) { should match /19532/ }
    end
  end

  describe 'overrides the service options' do
    describe file('/etc/systemd/system/systemd-journal-gatewayd.service.d/local-journal-gatewayd-options.conf') do
      it { should be_file }
      its(:content) { should match %r{[Service]} }
      its(:content) { should match /^ExecStart=$/ }
      its(:content) { should match %r{ExecStart=/usr/lib/systemd/systemd-journal-gatewayd --cert=/etc/pki/tls/certs/journal-gatewayd.cert --key=/etc/pki/tls/private/journal-gatewayd.key} }
    end

    describe command('systemctl show systemd-journal-gatewayd.service --property ExecStart') do
      its(:stdout) { should match %r{/usr/lib/systemd/systemd-journal-gatewayd --cert=/etc/pki/tls/certs/journal-gatewayd.cert --key=/etc/pki/tls/private/journal-gatewayd.key} }
    end
  end
end
