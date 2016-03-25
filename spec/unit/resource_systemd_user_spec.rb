require 'spec_helper'

describe ChefSystemdCookbook::UserResource do
  let(:user) do
    u = ChefSystemdCookbook::UserResource.new('user')
    u.dump_core true
    u.crash_shell false # crash override
    u
  end

  let(:hash) do
    {"Manager"=>["DumpCore=yes", "CrashShell=no"]}
  end

  it 'generates a proper hash' do
    expect(user.to_hash).to eq hash
  end
end
