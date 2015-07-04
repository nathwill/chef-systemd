require 'spec_helper'

describe 'systemd::default' do
  describe file('/etc/systemd/system/test-unit.service') do
    it { should be_file }
    its(:content) { should match /\[Unit\]/ }
    its(:content) { should match /Documentation/ }
  end
end
