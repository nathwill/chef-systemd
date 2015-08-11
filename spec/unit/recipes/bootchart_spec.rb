require 'spec_helper'

describe 'systemd::bootchart' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'manages the bootchart' do
      expect(chef_run).to create_systemd_bootchart('bootchart').with(
        drop_in: false,
        output: '/run/log'
      )
    end
    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
