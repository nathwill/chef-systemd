require 'spec_helper'

describe ChefSystemdCookbook::TimerResource do
  let(:timer) do
    t = ChefSystemdCookbook::TimerResource.new('target')
    t.wanted_by 'multi-user.target'
    t.after 'network.target'
    t.on_calendar 'hourly'
    t.wake_system true
    t
  end

  let(:hash) do
    {
      :unit=>["After=network.target"],
      :install=>["WantedBy=multi-user.target"],
      :timer=>["OnCalendar=hourly", "WakeSystem=yes"]
    }
  end

  it 'generates a proper hash' do
    expect(timer.to_hash).to eq hash
  end
end
