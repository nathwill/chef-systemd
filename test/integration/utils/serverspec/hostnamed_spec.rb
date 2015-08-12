require 'spec_helper'

describe 'Hostnamed' do
  describe 'sets the hostname' do
    describe file('/etc/hostname') do
      it { should be_file }
      its(:content) { should match /systemd-hostnamed-test.localdomain/ }
    end

    describe command('hostname') do
      its(:stdout) { should match /systemd-hostnamed-test.localdomain/ }
    end
  end
end
