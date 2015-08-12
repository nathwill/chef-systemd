require 'spec_helper'

describe 'Timesyncd' do
  describe 'configures the global config' do
    describe file('/etc/systemd/timesyncd.conf') do
      it { should be_file }
      its(:content) { should match %r{[Time]} }
      its(:content) { should match /NTP=0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org/ }
      its(:content) { should match /FallbackNTP=0.(fedora|debian|ubuntu|centos).pool.ntp.org 1.(fedora|debian|ubuntu|centos).pool.ntp.org 2.(fedora|debian|ubuntu|centos).pool.ntp.org 3.(fedora|debian|ubuntu|centos).pool.ntp.org/ }
    end
  end

  describe 'configures drop-in' do
    describe file('/etc/systemd/timesyncd.conf.d/local-ntp.conf') do
      it { should be_file }
      its(:content) { should match %r{[Time]} }
      its(:content) { should match /NTP=0.north-america.pool.ntp.org 1.north-america.pool.ntp.org 2.north-america.pool.ntp.org 3.north-america.pool.ntp.org/ }
    end
  end

  describe 'enables the service' do
    describe service('systemd-timesyncd') do
      it { should be_enabled }
    end
  end
end
