require 'spec_helper'

describe Chef::Resource::SystemdDevice do
  let(:device) do
    d = Chef::Resource::SystemdDevice.new('device')
    d.wanted_by 'multi-user.target'
    d.after 'network.target'
    d
  end

  let(:hash) do
    {
      :unit=>["After=network.target"],
      :install=>["WantedBy=multi-user.target"]
    }
  end

  it 'generates a proper hash' do
    expect(device.to_hash).to eq hash
  end
end
