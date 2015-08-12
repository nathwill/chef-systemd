require 'spec_helper'

describe 'Sysctl' do
  describe file('/etc/sysctl.d/vm.swappiness.conf') do
    it { should be_file }
    its(:content) { should match /vm.swappiness=10/ }
  end

  describe command('sysctl vm.swappiness') do
    its(:stdout) { should match /vm.swappiness = 10/ }
  end
end
