require 'spec_helper'

describe 'systemd::machine' do
  context 'default' do
    cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'installs btrfs tools' do
      expect(chef_run).to install_package 'btrfs-progs'
    end

    it 'does not set machine limits' do
      expect(chef_run).to_not run_execute('set-machined-pool-limit')
    end
  end

  context 'debian' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'debian', version: '9.0')
                            .converge(described_recipe)
    end

    it 'installs container tools' do
      expect(chef_run).to install_apt_package 'systemd-container'
    end

    it 'installs btrfs tools' do
      expect(chef_run).to install_package 'btrfs-tools'
    end
  end

  context 'with machine limits' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['systemd']['machine_pool_limit'] = '5G'
      end.converge(described_recipe)
    end

    it 'sets the machine limits' do
      expect(chef_run).to run_execute('set-machined-pool-limit').with(
        command: 'machinectl set-limit 5G'
      )
    end
  end
end
