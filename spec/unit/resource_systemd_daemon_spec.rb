require 'spec_helper'

describe ChefSystemdCookbook::DaemonResource do
  let(:daemon) do
    d = ChefSystemdCookbook::JournaldResource.new('journal')
    d.storage 'auto'
    d.forward_to_syslog true
    d.compress true
    d
  end

  let(:hash) do
    {"Journal"=>["Storage=auto", "Compress=yes", "ForwardToSyslog=yes"]}
  end

  it 'generates a proper hash' do
    expect(daemon.to_hash).to eq hash
  end
end
