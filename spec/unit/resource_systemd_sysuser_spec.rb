require 'spec_helper'

describe Chef::Resource::SystemdSysuser do
  let(:sysuser) do
    u = Chef::Resource::SystemdSysuser.new('_testuser')
    u.id 65_530
    u.gecos 'my test user'
    u.home '/var/lib/testuser'
    u
  end

  let(:str) do
    "u _testuser 65530 \"my test user\" /var/lib/testuser"
  end

  it 'generates a proper string' do
    expect(sysuser.as_string).to eq str
  end
end
