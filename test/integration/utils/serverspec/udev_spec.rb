require 'spec_helper'

describe 'Udev' do
  describe file('/etc/udev/udev.conf') do
    it { should be_file }
    its(:content) { should match /udev_log=info/ }
  end
end
