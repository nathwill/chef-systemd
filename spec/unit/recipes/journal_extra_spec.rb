require 'spec_helper'

describe 'systemd::journal_extra' do
  context 'rhel' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new.converge(described_recipe)
    end

    it 'installs the package' do
      expect(chef_run).to install_package 'systemd-journal-gateway'
    end
  end

  context 'debian' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'debian', version: '8.2')
                            .converge(described_recipe)
    end

    it 'installs the package' do
      expect(chef_run).to install_package('systemd-journal-remote').with(
        default_release: 'jessie-backports'
      )
    end
  end
end
