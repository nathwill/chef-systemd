#
# Cookbook Name:: systemd
# Spec:: daemons
#
# Copyright 2015 -2016, The Authors
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

%w( journald networkd resolved timesyncd ).each do |svc|
  describe "systemd::#{svc}" do
    context 'When all attributes are default, on an unspecified platform' do
      let(:chef_run) do
        runner = ChefSpec::ServerRunner.new
        runner.converge(described_recipe)
      end

      it 'enables/starts the service' do
        expect(chef_run).to enable_service("systemd-#{svc}")
        expect(chef_run).to start_service("systemd-#{svc}")
      end

      it 'converges successfully' do
        chef_run # This should not raise an error
      end
    end
  end
end

describe 'systemd::logind' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'does nothing' do
      expect(chef_run).to_not enable_service('systemd-logind')
      expect(chef_run).to_not start_service('systemd-logind')
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end

describe 'systemd::networkd' do
  context 'On RHEL platforms' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.0')
      runner.converge(described_recipe)
    end

    it 'installs systemd-networkd' do
      expect(chef_run).to install_package('systemd-networkd')
    end
  end
end
