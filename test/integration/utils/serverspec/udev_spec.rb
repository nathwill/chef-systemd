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

describe 'udevd recipe sets non-usr-merged exec_start path', :if => os[:family].match(/(debian|ubuntu)/) do
  describe file('/etc/systemd/system/systemd-udevd.service.d/local-udevd-options.conf') do
    its(:content) { should_not match Regexp.new('ExecStart=/usr/lib/systemd/systemd-udevd') }
    its(:content) { should match Regexp.new('ExecStart=/lib/systemd/systemd-udevd --children-max=10') }
  end
end

describe 'udevd recipe sets usr-merged exec_start path', :if => os[:family].match(/(redhat|fedora)/) do
  describe file('/etc/systemd/system/systemd-udevd.service.d/local-udevd-options.conf') do
    its(:content) { should match Regexp.new('ExecStart=/usr/lib/systemd/systemd-udevd --children-max=10') }
    its(:content) { should_not match Regexp.new('ExecStart=/lib/systemd/systemd-udevd') }
  end
end
