require 'spec_helper'

describe ChefSystemdCookbook::SwapResource do
  let(:swap) do
    s = ChefSystemdCookbook::SwapResource.new('swap')
    s.wanted_by 'multi-user.target'
    s.after 'network.target'
    s.what '/dev/swap'
    s.timeout_sec '30'
    s
  end

  let(:hash) do
    {
      :unit=>["After=network.target"],
      :install=>["WantedBy=multi-user.target"],
      :swap=>["What=/dev/swap", "TimeoutSec=30"]
    }
  end

  it 'generates a proper hash' do
    expect(swap.to_hash).to eq hash
  end
end
