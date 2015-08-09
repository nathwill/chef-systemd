require 'spec_helper'

describe 'Hostnamed' do
  describe 'sets the hostname' do
    describe command('hostname') do
      its(:stdout) { should match /systemd-hostnamed-test.localdomain/ }
    end
  end
end
