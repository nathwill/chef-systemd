require 'spec_helper'

describe 'systemd::default' do
  describe file('/etc/systemd/system/test-unit.service') do
    its(:md5sum) { should eq '9e76cbbef085b029d2bbf64ef9b3782d' }
  end
end
