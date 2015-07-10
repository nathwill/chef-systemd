require 'spec_helper'

describe Chef::Resource::SystemdUnit do
  let(:unit) do
    u = Chef::Resource::SystemdService.new('service')
    u.description 'test unit'
    u.documentation 'http://example.com'
    u.wanted_by 'multi-user.target'
    u.exec_start '/usr/bin/true'
    u.memory_limit '1G'
    u
  end

  let(:hash) do
    {
      :unit=>["Description=test unit", "Documentation=http://example.com"],
      :install=>["WantedBy=multi-user.target"],
      :service=>["MemoryLimit=1G", "ExecStart=/usr/bin/true"]
    }
  end

  it 'generates a proper hash' do
    expect(unit.to_hash).to eq hash
  end
end
