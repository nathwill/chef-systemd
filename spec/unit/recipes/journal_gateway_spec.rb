require 'spec_helper'

describe 'systemd::journal_gateway' do
  context 'default' do
    cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'installs the package' do
      expect(chef_run).to include_recipe('systemd::journal_extra')
    end

    it 'handles the service' do
      expect(chef_run).to enable_service('systemd-journal-gatewayd')
      expect(chef_run).to start_service('systemd-journal-gatewayd')
    end
  end
end
