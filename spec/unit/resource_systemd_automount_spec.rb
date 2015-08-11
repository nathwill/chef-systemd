require 'spec_helper'

describe Chef::Resource::SystemdAutomount do
  let(:automount) do
    a = Chef::Resource::SystemdAutomount.new('automount')
    a.wanted_by 'multi-user.target'
    a.after 'network.target'
    a.where '/srv/automount'
    a.directory_mode '0750'
    a
  end

  let(:hash) do
    {
      :unit=>["After=network.target"],
      :install=>["WantedBy=multi-user.target"],
      :automount=>["Where=/srv/automount", "DirectoryMode=0750"]
    }
  end

  it 'generates a proper hash' do
    expect(automount.to_hash).to eq hash
  end
end
