require 'spec_helper'

describe 'systemd::networkd' do
  context 'rhel' do
    cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'installs the package' do
      expect(chef_run).to install_package 'systemd-networkd'
    end

    it 'manages the service' do
      expect(chef_run).to enable_service('systemd-networkd')
      expect(chef_run).to start_service('systemd-networkd')
    end
  end
end
