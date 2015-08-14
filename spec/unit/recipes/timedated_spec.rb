require 'spec_helper'

describe 'systemd::timedated' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'does not enable/start the service' do
      expect(chef_run).to enable_service('systemd-timedated')
    end
  end
end
