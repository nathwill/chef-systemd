require 'spec_helper'

describe ChefSystemdCookbook::CoredumpResource do
  let(:coredump) do
    c = ChefSystemdCookbook::CoredumpResource.new('coredump')
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
