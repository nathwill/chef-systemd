require 'spec_helper'

describe 'Networkd' do
  describe service('systemd-networkd') do
    it { should be_enabled }
    it { should be_running }
  end
end
