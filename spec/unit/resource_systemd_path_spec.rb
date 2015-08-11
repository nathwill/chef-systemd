require 'spec_helper'

describe Chef::Resource::SystemdPath do
  let(:path) do
    p = Chef::Resource::SystemdPath.new('path')
    p.wanted_by 'multi-user.target'
    p.after 'network.target'
    p.unit 'worker.service'
    p.directory_not_empty '/var/tmp/work'
    p.make_directory 'yes'
    p
  end

  let(:hash) do
    {
      :unit => ["After=network.target"],
      :install => ["WantedBy=multi-user.target"],
      :path => ["DirectoryNotEmpty=/var/tmp/work", "Unit=worker.service", "MakeDirectory=yes"]
    }
  end

  it 'generates a proper hash' do
    expect(path.to_hash).to eq hash
  end
end
