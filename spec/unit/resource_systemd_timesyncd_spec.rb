require 'spec_helper'

describe ChefSystemdCookbook::TimesyncdResource do
  let(:timesyncd) do
    t = ChefSystemdCookbook::TimesyncdResource.new('timesyncd')
    t.ntp '0.pool.ntp.org'
    t.fallback_ntp '0.centos.pool.ntp.org'
    t
  end

  let(:hash) do
    {
      "Time"=>["NTP=0.pool.ntp.org", "FallbackNTP=0.centos.pool.ntp.org"]
    }
  end

  it 'generates a proper hash' do
    expect(timesyncd.to_hash).to eq hash
  end
end
