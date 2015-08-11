require 'spec_helper'

describe Chef::Resource::SystemdBootchart do
  let(:bootchart) do
    b = Chef::Resource::SystemdBootchart.new('bootchart')
    b.output '/var/tmp'
    b
  end

  let(:hash) do
    {:Bootchart=>["Output=/var/tmp"]}
  end

  it 'generates a proper hash' do
    expect(bootchart.to_hash).to eq hash
  end
end
