require 'spec_helper'

describe 'Logind' do
  describe 'configures the global config' do
    describe file('/etc/systemd/logind.conf') do
      it { should be_file }
      its(:content) { should match %r{[Login]} }
      its(:content) { should match /NAutoVTs=0/ }
    end
  end

  describe 'configures drop-in' do
    describe file('/etc/systemd/logind.conf.d/local-ipc.conf') do
      it { should be_file }
      its(:content) { should match %r{[Login]} }
      its(:content) { should match /RemoveIPC=no/ }
    end
  end

  describe 'enables the service' do
    describe service('systemd-logind') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
