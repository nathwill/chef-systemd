require 'spec_helper'

describe Chef::Resource::SystemdTarget do
  let(:target) do
    t = Chef::Resource::SystemdTarget.new('target')
    t.wanted_by 'multi-user.target'
    t.after 'network.target'
    t
  end

  let(:hash) do
    {
      :unit=>["After=network.target"],
      :install=>["WantedBy=multi-user.target"],
    }
  end

  it 'generates a proper hash' do
    expect(target.to_hash).to eq hash
  end
end
