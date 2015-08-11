require 'spec_helper'

describe Chef::Resource::SystemdCoredump do
  let(:coredump) do
    c = Chef::Resource::SystemdCoredump.new('coredump')
    c.compress 'yes'
    c.storage 'auto'
    c
  end

  let(:hash) do
    {:Coredump=>["Storage=auto", "Compress=yes"]}
  end

  it 'generates a proper hash' do
    expect(coredump.to_hash).to eq hash
  end
end
