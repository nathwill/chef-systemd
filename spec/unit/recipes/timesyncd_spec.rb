require 'spec_helper'

describe 'systemd::timesyncd' do
  context 'When all attributes are default' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'fedora', version: 21)
      runner.converge(described_recipe)
    end

    it 'configures timesyncd' do
      expect(chef_run).to create_systemd_timesyncd('timesyncd').with(
        ntp: %w(0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org),
        fallback_ntp: %w(0.fedora.pool.ntp.org 1.fedora.pool.ntp.org 2.fedora.pool.ntp.org 3.fedora.pool.ntp.org)
      )
    end

    it 'enables/starts the service' do
      expect(chef_run).to enable_service('systemd-timesyncd')
      expect(chef_run).to start_service('systemd-timesyncd')
    end

    it 'notifies service to restart' do
      t = chef_run.systemd_timesyncd('timesyncd')
      expect(t).to notify('service[systemd-timesyncd]').to(:restart).delayed
    end
  end
end
