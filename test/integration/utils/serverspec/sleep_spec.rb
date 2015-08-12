require 'spec_helper'

describe 'Sleep' do
  describe file('/etc/systemd/sleep.conf') do
    it { should be_file }
    its(:content) { should match %r{[Sleep]} }
    its(:content) { should match /SuspendState=freeze/ }
  end
end
