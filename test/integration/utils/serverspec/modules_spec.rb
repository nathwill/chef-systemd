require 'spec_helper'

describe 'Modules' do
  describe file('/etc/modprobe.d/die-beep-die.conf') do
    it { should be_file }
    its(:content) { should match /blacklist pcspkr/ }
  end

  describe kernel_module('pcspkr') do
    it { should_not be_loaded }
  end

  describe file('/etc/modules-load.d/zlib.conf') do
    it { should be_file }
    its(:content) { should match /zlib/ }
  end

  describe kernel_module('zlib') do
    it { should be_loaded }
  end
end
