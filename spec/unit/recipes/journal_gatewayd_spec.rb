require 'spec_helper'

describe 'systemd::journal_gatewayd' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'installs package' do
      expect(chef_run).to install_package('systemd-journal-gateway')
    end

    it 'does not override socket options' do
      expect(chef_run).to_not create_systemd_socket('local-journal-gatewayd-listen-stream')
    end

    it 'does not override service options' do
      expect(chef_run).to_not create_systemd_service('local-journal-gatewayd-options')
    end

    it 'enables, starts the socket' do
      expect(chef_run).to enable_systemd_socket('systemd-journal-gatewayd')
      expect(chef_run).to start_systemd_socket('systemd-journal-gatewayd')
    end

    it 'does not start the service' do
      expect(chef_run).to_not enable_service('systemd-journal-gatewayd')
      expect(chef_run).to_not start_service('systemd-journal-gatewayd')
    end
  end

  context 'with socket/service overrides, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['systemd']['journal_gatewayd']['listen_stream'] = '19532'
        node.set['systemd']['journal_gatewayd']['options']['cert'] = '/etc/pki/tls/certs/journal-gatewayd.cert'
        node.set['systemd']['journal_gatewayd']['options']['key'] = '/etc/pki/tls/private/journal-gatewayd.key'
      end
      runner.converge(described_recipe)
    end

    it 'overrides socket options' do
      expect(chef_run).to create_systemd_socket('local-journal-gatewayd-listen-stream').with(
        drop_in: true,
        override: 'systemd-journal-gatewayd',
        overrides: ['ListenStream'],
        listen_stream: '19532'
      )
    end

    it 'overrides service options' do
      expect(chef_run).to create_systemd_service('local-journal-gatewayd-options').with(
        drop_in: true,
        override: 'systemd-journal-gatewayd',
        overrides: ['ExecStart'],
        exec_start: '/usr/lib/systemd/systemd-journal-gatewayd --cert=/etc/pki/tls/certs/journal-gatewayd.cert --key=/etc/pki/tls/private/journal-gatewayd.key'
      )
    end

    it 'stops the service' do
      s = chef_run.systemd_service('local-journal-gatewayd-options')
      expect(s).to notify('service[systemd-journal-gatewayd]').to(:stop).delayed
    end
  end
end
