require 'spec_helper'

describe 'systemd::timesyncd' do
  context 'rhel' do
    cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'manages the service' do
      expect(chef_run).to enable_service 'systemd-timesyncd'
      expect(chef_run).to start_service 'systemd-timesyncd'
    end
  end
end
