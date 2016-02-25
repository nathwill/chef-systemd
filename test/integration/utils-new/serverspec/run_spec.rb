require 'spec_helper'

describe 'SystemdRun' do
  describe port(2222) do
    it { should be_listening }
  end

  describe service('sshd-2222') do
    it { should be_running }
  end
end
