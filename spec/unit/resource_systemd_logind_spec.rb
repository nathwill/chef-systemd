require 'spec_helper'

describe Chef::Resource::SystemdLogind do
  let(:logind) do
    l = Chef::Resource::SystemdLogind.new('logind')
    l.remove_ipc 'yes'
    l
  end

  let(:hash) do
    {
      "Login"=>["RemoveIPC=yes"]
    }
  end

  it 'generates a proper hash' do
    expect(logind.to_hash).to eq hash
  end
end
