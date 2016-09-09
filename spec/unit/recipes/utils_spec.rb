#
# Cookbook Name:: systemd
# Spec:: utils
#
# Copyright 2015 - 2016, The Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

describe 'systemd::binfmt' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'does nothing' do
      expect(chef_run).to_not enable_service('systemd-binfmt')
      expect(chef_run).to_not start_service('systemd-binfmt')
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end

describe 'systemd::hostname' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'does not manage /etc/hostname' do
      expect(chef_run).to_not create_file('/etc/hostname')
    end

    it 'does not execute hostnamectl' do
      expect(chef_run).to_not run_execute('set-hostname')
    end

    it 'does not manage systemd-hostnamed' do
      expect(chef_run).to_not enable_service('systemd-hostnamed')
      expect(chef_run).to_not start_service('systemd-hostnamed')
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  context 'when the hostname is set, on an unspecified platform' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.normal['systemd']['hostname'] = 'my-hostname'
      end.converge(described_recipe)
    end

    it 'manages /etc/hostname' do
      expect(chef_run).to render_file('/etc/hostname').with_content('my-hostname')
    end

    it 'sets the hostname' do
      file = chef_run.file('/etc/hostname')
      expect(file).to notify('execute[set-hostname]').to(:run).immediately
    end

    it 'has valid hostnamectl command' do
      expect(chef_run).to_not run_execute('set-hostname').with(command: 'hostnamectl set-hostname my-hostname')
    end

    it 'does not manage systemd-hostnamed' do
      expect(chef_run).to_not enable_service('systemd-hostnamed')
      expect(chef_run).to_not start_service('systemd-hostnamed')
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
