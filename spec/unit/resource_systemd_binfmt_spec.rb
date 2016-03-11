require 'spec_helper'

describe ChefSystemdCookbook::BinfmtResource do
  let(:binfmt) do
    b = ChefSystemdCookbook::BinfmtResource.new('DOSWin')
    b.magic 'MZ'
    b.interpreter '/usr/bin/wine'
    b
  end

  let(:string) { ':DOSWin:M::MZ::/usr/bin/wine:' }

  it 'generates a proper string' do
    expect(binfmt.as_string).to eq string
  end
end
