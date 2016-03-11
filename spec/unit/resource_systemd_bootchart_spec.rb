require 'spec_helper'

describe ChefSystemdCookbook::BootchartResource do
  let(:bootchart) do
    b = ChefSystemdCookbook::BootchartResource.new('bootchart')
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
