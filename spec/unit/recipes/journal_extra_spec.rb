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
      ChefSpec::ServerRunner.new(platform: 'debian', version: '9.0')
                            .converge(described_recipe)
    end

    it 'installs the package' do
      expect(chef_run).to install_apt_package('systemd-journal-remote').with(
        default_release: 'stretch-backports'
      )
    end
  end
end
