#
# Cookbook Name:: systemd
# Spec:: hostnamed
#
# Copyright 2015 The Authors
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

describe 'systemd::hostnamed' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'does not set the hostname' do
      expect(chef_run).to_not create_file('/etc/hostname')
    end

    it 'does not start the service' do
      expect(chef_run).to_not start_service('systemd-hostnamed')
    end
    
    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end

  context 'When the hostname is set, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['systemd']['hostname'] = 'jabberwocky.localdomain'
      end

      runner.converge(described_recipe)
    end

    it 'sets the hostname' do
      expect(chef_run).to create_file('/etc/hostname').with(content: 'jabberwocky.localdomain')
    end

    it 'restarts the service' do
      file = chef_run.file('/etc/hostname')
      expect(file).to notify('service[systemd-hostnamed]').to(:restart).immediately
    end
  end
end
