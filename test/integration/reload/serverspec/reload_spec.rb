require 'spec_helper'

describe command('systemctl show vsftpd.service -p CPUAccounting -p CPUShares') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /CPUAccounting=yes/ }
  its(:stdout) { should match /CPUShares=1200/ }
end
