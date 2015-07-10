#
# Cookbook Name:: setup
# Spec:: default
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

describe 'setup' do
  let(:unit_types) do
    %w(service socket device mount automount swap target path timer slice).map{|t| "systemd_#{t}"}
  end

  cached(:chef_run) do
    runner = ChefSpec::SoloRunner.new(step_into: unit_types)
    runner.converge(described_recipe)
  end

  it '#service' do
    expect(chef_run).to create_systemd_service('test-unit').with(
      description: 'Test Service',
      documentation: 'man:true(1)',
      aliases: %w( testing-unit testd ),
      wanted_by: 'multi-user.target',
      user: 'nobody',
      kill_signal: 'SIGTERM',
      memory_limit: '5M',
      type: 'oneshot',
      exec_start: '/usr/bin/true'
    )

    expect(chef_run).to create_file('/etc/systemd/system/test-unit.service')
  end

  it '#drop_in' do
    expect(chef_run).to create_systemd_service('my-override').with(
      description: 'Test Override',
      drop_in: true,
      aliases: %w( ssh openssh ),
      cpu_quota: '10%'
    )
  end

  it '#socket' do
    expect(chef_run).to create_systemd_socket('sshd').with(
      description: 'SSH Socket for Per-Connection Servers',
      listen_stream: '22',
      accept: 'yes',
      protect_system: 'full',
      kill_mode: 'control-group',
      cpu_quota: '20%',
      wanted_by: 'sockets.target'
    )
  end

  it '#device' do
    expect(chef_run).to create_systemd_device('vdb').with(
      description: 'Test Device',
      wanted_by: 'multi-user.target',
    )
  end

  it '#mount' do
    expect(chef_run).to create_systemd_mount('tmp-mount').with(
      description: 'Test Mount',
      documentation: 'man:hier(7)',
      default_dependencies: 'no',
      conflicts: 'umount.target',
      before: 'local-fs.target umount.target',
      wanted_by: 'local-fs.target',
      what: 'tmpfs',
      where: '/tmp',
      type: 'tmpfs',
      timeout_sec: '300',
      io_scheduling_priority: '0',
      kill_mode: 'mixed',
      slice: 'system.slice',
      options: 'mode=1777,strictatime'
    )
  end

  it '#automount' do
    expect(chef_run).to create_systemd_automount('vagrant-home').with(
      description: 'Test Automount',
      wanted_by: 'local-fs.target',
      where: '/home/vagrant'
    )
  end

  it '#swap' do
    expect(chef_run).to create_systemd_swap('swap').with(
      description: 'Test Swap',
      wanted_by: 'local-fs.target',
      what: '/dev/swap',
      timeout_sec: '5',
      personality: 'x86',
      send_sighup: 'no',
      block_io_accounting: 'true'
    )
  end

  it '#target' do
    expect(chef_run).to create_systemd_target('test').with(
      description: 'Test Target',
      documentation: 'man:systemd.special(7)',
      stop_when_unneeded: 'yes',
      aliases: %w( tested )
    )
  end

  it '#path' do
    expect(chef_run).to create_systemd_path('dummy').with(
      description: 'Test Path',
      wanted_by: 'multi-user.target',
      directory_not_empty: '/var/run/queue',
      unit: 'queue-worker.service',
      make_directory: 'true'
    )
  end

  it '#timer' do
    expect(chef_run).to create_systemd_timer('clean-tmp').with(
      description: 'Test Timer',
      documentation: 'man:tmpfiles.d(5) man:systemd-tmpfiles(8)',
      on_boot_sec: '15min',
      on_unit_active_sec: '1d',
      wanted_by: 'multi-user.target'
    )
  end

  it '#slice' do
    expect(chef_run).to create_systemd_slice('customer-1').with(
      description: 'Test Slice',
      memory_limit: '1G',
      cpu_shares: '1024',
      wanted_by: 'multi-user.target'
    )
  end

  it '#lifecycle' do
    expect(chef_run).to disable_systemd_service('rsyslog')
    expect(chef_run).to stop_systemd_service('rsyslog')
  end
end
