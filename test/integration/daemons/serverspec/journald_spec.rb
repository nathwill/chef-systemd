require 'spec_helper'

describe 'Journald' do
  describe 'configures the global config' do
    describe file('/etc/systemd/journald.conf') do
      it { should be_file }
      its(:content) { should match %r{[Journal]} }
      its(:content) { should match /Storage=auto/ }
    end
  end

  describe 'configures drop-in' do
    describe file('/etc/systemd/journald.conf.d/local-syslog.conf') do
      it { should be_file }
      its(:content) { should match %r{[Journal]} }
      its(:content) { should match /ForwardToSyslog=yes/ }
    end
  end

  describe 'enables/starts the service' do
    describe service('systemd-journald') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
