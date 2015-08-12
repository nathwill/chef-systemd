require 'spec_helper'

describe 'System' do
  describe file('/etc/systemd/user.conf') do
    it { should be_file }
    its(:content) { should match %r{[Manager]} }
    its(:content) { should match /RuntimeWatchdogSec=30/ }
  end
end
