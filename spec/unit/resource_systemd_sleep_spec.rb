require 'spec_helper'

describe ChefSystemdCookbook::SleepResource do
  let(:sleep) do
    s = ChefSystemdCookbook::SleepResource.new('sleep')
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
