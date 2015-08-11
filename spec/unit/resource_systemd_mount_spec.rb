require 'spec_helper'

describe Chef::Resource::SystemdMount do
  let(:mount) do
    m = Chef::Resource::SystemdMount.new('mount')
    m.wanted_by 'multi-user.target'
    m.after 'network.target'
    m.what '/dev/vda'
    m.where '/srv/automount'
    m
  end

  let(:hash) do
    {
      :unit=>["After=network.target"],
      :install=>["WantedBy=multi-user.target"],
      :mount=>["What=/dev/vda", "Where=/srv/automount"]
    }
  end

  it 'generates a proper hash' do
    expect(mount.to_hash).to eq hash
  end
end
