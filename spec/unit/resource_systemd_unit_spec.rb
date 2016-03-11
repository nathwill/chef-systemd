require 'spec_helper'

describe ChefSystemdCookbook::UnitResource do
  let(:unit) do
    u = ChefSystemdCookbook::ServiceResource.new('service')
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
      :service=>["ExecStart=/usr/bin/true", "MemoryLimit=1G"]
    }
  end

  it 'generates a proper hash' do
    expect(unit.to_hash).to eq hash
  end
end
