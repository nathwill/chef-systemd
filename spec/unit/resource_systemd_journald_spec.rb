require 'spec_helper'

describe Chef::Resource::SystemdJournald do
  let(:journald) do
    d = Chef::Resource::SystemdJournald.new('journal')
    d.storage 'auto'
    d.forward_to_syslog true
    d.compress true
    d
  end

  let(:hash) do
    {
      "Journal"=>["Storage=auto", "Compress=yes", "ForwardToSyslog=yes"]
    }
  end

  it 'generates a proper hash' do
    expect(journald.to_hash).to eq hash
  end
end
