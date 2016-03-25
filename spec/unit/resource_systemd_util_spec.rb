require 'spec_helper'

describe ChefSystemdCookbook::UtilResource do
  let(:util) do
    u = ChefSystemdCookbook::UtilResource.new('util')
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
