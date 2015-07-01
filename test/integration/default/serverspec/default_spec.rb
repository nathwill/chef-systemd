require 'spec_helper'

describe 'systemd::default' do
  describe file('/etc/systemd/system/test-unit.service') do
    its(:md5sum) { should eq '442b51d7c0c98fe33c52558f10bcc7d2' }
  end
end
