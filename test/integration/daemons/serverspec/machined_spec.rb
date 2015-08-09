require 'spec_helper'

describe 'Machined' do
  describe 'enables/starts the service' do
    describe service('systemd-machined') do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
