require 'spec_helper'

describe 'systemd::locale' do
  context 'default' do
    cached(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

    it 'manages locale.conf' do
      expect(chef_run).to create_file('/etc/locale.conf').with(
        content: "LANG=en_US.UTF-8"
      )
    end

    it 'applies locale' do
      expect(chef_run.file('/etc/locale.conf')).to notify('service[systemd-localed]').to(:restart).immediately
    end
  end
end
