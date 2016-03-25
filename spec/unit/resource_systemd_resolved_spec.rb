require 'spec_helper'

describe ChefSystemdCookbook::ResolvedResource do
  let(:resolved) do
    r = ChefSystemdCookbook::ResolvedResource.new('resolved')
    r.dns '8.8.8.8 8.8.4.4'
    r.fallback_dns '208.67.222.222 208.67.220.220'
    r
  end

  let(:hash) do
    {
      "Resolve"=>["DNS=8.8.8.8 8.8.4.4", "FallbackDNS=208.67.222.222 208.67.220.220"]
    }
  end

  it 'generates a proper hash' do
    expect(resolved.to_hash).to eq hash
  end
end
