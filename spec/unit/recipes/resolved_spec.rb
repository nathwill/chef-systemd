require 'spec_helper'

describe 'systemd::resolved' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'configures resolved' do
      expect(chef_run).to create_systemd_resolved('resolved').with(
        dns: %w(8.8.8.8 8.8.4.4),
      )
    end

    it 'enables/starts the service' do
      expect(chef_run).to enable_service('systemd-resolved')
      expect(chef_run).to start_service('systemd-resolved')
    end

    it 'notifies service to restart' do
      r = chef_run.systemd_resolved('resolved')
      expect(r).to notify('service[systemd-resolved]').to(:restart).delayed
    end
  end
end
