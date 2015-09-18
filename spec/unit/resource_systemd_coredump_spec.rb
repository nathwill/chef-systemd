require 'spec_helper'

describe Chef::Resource::SystemdCoredump do
  let(:coredump) do
    c = Chef::Resource::SystemdCoredump.new('coredump')
    c.compress true
    c.storage 'external'
    c
  end

  let(:hash) do
    {:Coredump=>["Storage=external", "Compress=yes"]}
  end

  it 'generates a proper hash' do
    expect(coredump.to_hash).to eq hash
  end
end
