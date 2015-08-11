require 'spec_helper'

describe Chef::Resource::SystemdService do
  let(:service) do
    s = Chef::Resource::SystemdService.new('service')
    s.description 'test unit'
    s.documentation 'http://example.com'
    s.wanted_by 'multi-user.target'
    s.exec_start '/usr/bin/true'
    s.memory_limit '1G'
    s
  end

  let(:hash) do
    {
      :unit=>["Description=test unit", "Documentation=http://example.com"],
      :install=>["WantedBy=multi-user.target"],
      :service=>["MemoryLimit=1G", "ExecStart=/usr/bin/true"]
    }
  end

  it 'generates a proper hash' do
    expect(service.to_hash).to eq hash
  end
end
