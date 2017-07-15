require 'spec_helper'

describe 'systemd::resolved' do
  context 'rhel' do
    cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'installs the pkg' do
      expect(chef_run).to install_package('systemd-resolved')
    end

    it 'manages the service' do
      expect(chef_run).to enable_service 'systemd-resolved'
      expect(chef_run).to start_service 'systemd-resolved'
    end
  end
end
