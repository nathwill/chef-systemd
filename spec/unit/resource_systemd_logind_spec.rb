require 'spec_helper'

describe ChefSystemdCookbook::LogindResource do
  let(:logind) do
    l = ChefSystemdCookbook::LogindResource.new('logind')
    l.remove_ipc true
    l
  end

  let(:hash) do
    {
      "Login"=>["RemoveIPC=yes"]
    }
  end

  it 'generates a proper hash' do
    expect(logind.to_hash).to eq hash
  end
end
