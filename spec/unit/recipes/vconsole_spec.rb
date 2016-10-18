require 'spec_helper'

describe 'systemd::vconsole' do
  context 'default' do
    cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'manages vconsole.conf' do
      expect(chef_run).to create_file('/etc/vconsole.conf').with(
        content: "KEYMAP=us\nFONT=latarcyrheb-sun16"
      )
    end

    it 'applies locale' do
      expect(chef_run.file('/etc/vconsole.conf')).to notify('service[systemd-vconsole-setup]').to(:restart).immediately
    end
  end
end
