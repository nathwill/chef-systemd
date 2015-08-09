require 'spec_helper'

describe 'systemd::journald' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'configures journald' do
      expect(chef_run).to create_systemd_journald('journald').with(
        storage: 'auto'
      )
    end

    it 'enables/starts the service' do
      expect(chef_run).to enable_service('systemd-journald')
      expect(chef_run).to start_service('systemd-journald')
    end

    it 'notifies service to restart' do
      j = chef_run.systemd_journald('journald')
      expect(j).to notify('service[systemd-journald]').to(:restart).delayed
    end
  end
end
