require 'spec_helper'

describe 'systemd::hostname' do
  context 'when all attributes are default on an unspecified platform' do
    cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'does not reload ohai' do
      expect(chef_run).to_not reload_ohai('hostname').with(
        plugin: 'hostname'
      )
    end

    it 'does not set the hostname' do
      expect(chef_run).to_not run_execute('set-hostname')
    end
  end

  context 'when hostname and fqdn differ' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.automatic['fqdn'] = 'a.example.com'
        node.normal['systemd']['hostname'] = 'b.example.com'
      end.converge(described_recipe)
    end

    it 'sets the hostname' do
      expect(chef_run).to run_execute('set-hostname').with(
        command: 'hostnamectl set-hostname b.example.com'
      )
    end

    it 'reloads ohai' do
      expect(chef_run.execute('set-hostname')).to notify('ohai[hostname]').to(:reload).immediately
    end
  end
end
