require 'spec_helper'

describe Chef::Resource::SystemdUtil do
  let(:util) do
    u = Chef::Resource::SystemdUtil.new('util')
    u.conf_type :bootchart
    u
  end

  it 'sets drop-in to true by default' do
    expect(util.drop_in).to eq true
  end

  it 'capitalizes the label' do
    expect(util.label).to eq :Bootchart
  end 
end
