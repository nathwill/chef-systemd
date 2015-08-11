require 'spec_helper'

describe Chef::Resource::SystemdSleep do
  let(:sleep) do
    s = Chef::Resource::SystemdSleep.new('sleep')
    s.suspend_state 'freeze'
    s
  end

  let(:hash) do
    {:Sleep=>["SuspendState=freeze"]}
  end

  it 'generates a proper hash' do
    expect(sleep.to_hash).to eq hash
  end
end
