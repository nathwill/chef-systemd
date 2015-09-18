require 'spec_helper'

describe 'systemd::logind' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'configures logind' do
      expect(chef_run).to create_systemd_logind('logind').with(
        n_auto_v_ts: 0
      )
    end

    it 'enables/starts the service' do
      expect(chef_run).to enable_service('systemd-logind')
      expect(chef_run).to start_service('systemd-logind')
    end

    it 'notifies service to restart' do
      j = chef_run.systemd_logind('logind')
      expect(j).to notify('service[systemd-logind]').to(:restart).delayed
    end
  end
end
