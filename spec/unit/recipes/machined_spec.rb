require 'spec_helper'

describe 'systemd::machined' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'does not enable/start the service' do
      expect(chef_run).to_not enable_service('systemd-machined')
      expect(chef_run).to_not start_service('systemd-machined')
    end
  end
end
