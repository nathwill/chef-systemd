require 'spec_helper'

describe Chef::Resource::SystemdBinfmtD do
  let(:binfmt_d) do
    b = Chef::Resource::SystemdBinfmtD.new('DOSWin')
    b.magic 'MZ'
    b.interpreter '/usr/bin/wine'
    b
  end

  let(:string) { ':DOSWin:M::MZ::/usr/bin/wine:' }

  it 'generates a proper string' do
    expect(binfmt_d.to_s).to eq string
  end
end
