require 'spec_helper'

describe 'systemd::timezone' do
  context 'when timezone differs' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new do |node|
        node.normal['time']['timezone'] = 'America/Los_Angeles'
        node.normal['systemd']['timezone'] = 'UTC'
      end.converge(described_recipe)
    end

    it 'sets the timezone' do
      expect(chef_run).to run_execute('set-timezone').with(
        command: 'timedatectl set-timezone UTC'
      )
    end

    it 'reloads ohai' do
      expect(chef_run.execute('set-timezone')).to notify('ohai[timezone]').to(:reload).immediately
    end
  end
end
