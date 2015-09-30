require 'spec_helper'

describe 'Udev' do
  describe file('/etc/udev/udev.conf') do
    it { should be_file }
    its(:content) { should match /udev_log="info"/ }
  end
end

describe 'udev rules' do
  describe file('/etc/udev/rules.d/udev-test.rules') do
    it { should be_file }
    its(:content) { should match /SUBSYSTEM=="block"/ }
  end
end
