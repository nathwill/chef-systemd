require 'spec_helper'

describe ChefSystemdCookbook::SliceResource do
  let(:slice) do
    s = ChefSystemdCookbook::SliceResource.new('slice')
    s.wanted_by 'multi-user.target'
    s.after 'network.target'
    s.memory_limit '1G'
    s.cpu_quota '1024'
    s
  end

  let(:hash) do
    {
      :unit=>["After=network.target"],
      :install=>["WantedBy=multi-user.target"],
      :slice=>["CPUQuota=1024", "MemoryLimit=1G"]
    }
  end

  it 'generates a proper hash' do
    expect(slice.to_hash).to eq hash
  end
end
