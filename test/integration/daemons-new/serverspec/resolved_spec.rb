require 'spec_helper'

describe 'Resolved' do
  describe 'configures the global config' do
    describe file('/etc/systemd/resolved.conf') do
      it { should be_file }
      its(:content) { should match %r{[Resolve]} }
      its(:content) { should match /DNS=8.8.8.8 8.8.4.4/ }
    end
  end

  describe 'configures drop-in' do
    describe file('/etc/systemd/resolved.conf.d/local-llmnr.conf') do
      it { should be_file }
      its(:content) { should match %r{[Resolve]} }
      its(:content) { should match /LLMNR=resolve/ }
    end
  end

  describe 'enables the service' do
    describe service('systemd-resolved') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
