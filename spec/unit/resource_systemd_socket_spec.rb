require 'spec_helper'

describe Chef::Resource::SystemdSocket do
  let(:socket) do
    s = Chef::Resource::SystemdSocket.new('socket')
    s.wanted_by 'multi-user.target'
    s.after 'network.target'
    s.listen_stream '8080'
    s
  end

  let(:hash) do
    {
      :unit=>["After=network.target"],
      :install=>["WantedBy=multi-user.target"],
      :socket=>["ListenStream=8080"]
    }
  end

  it 'generates a proper hash' do
    expect(socket.to_hash).to eq hash
  end
end
