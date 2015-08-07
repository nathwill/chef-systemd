#
# Cookbook Name:: systemd
# Recipe:: logind
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

l = node['systemd']['logind']

systemd_logind 'logind' do
  n_auto_v_ts l['n_auto_v_ts']
  reserve_vt l['reserve_vt']
  kill_user_processes l['kill_user_processes']
  kill_only_users l['kill_only_users']
  kill_exclude_users l['kill_exclude_users']
  idle_action l['idle_action']
  idle_action_sec l['idle_action_sec']
  inhibit_delay_max_sec l['inhibit_delay_max_sec']
  handle_power_key l['handle_power_key']
  handle_suspend_key l['handle_suspend_key']
  handle_hibernate_key l['handle_hibernate_key']
  handle_lid_switch l['handle_lid_switch']
  handle_lid_switch_docked l['handle_lid_switch_docked']
  power_key_ignore_inhibited l['power_key_ignore_inhibited']
  suspend_key_ignore_inhibited l['suspend_key_ignore_inhibited']
  hibernate_key_ignore_inhibited l['hibernate_key_ignore_inhibited']
  lid_switch_ignore_inhibited l['lid_switch_ignore_inhibited']
  holdoff_timeout_sec l['holdoff_timeout_sec']
  runtime_directory_size l['runtime_directory_size']
  remove_ipc l['remove_ipc']
  notifies :restart, 'service[systemd-logind]', :delayed
end

service 'systemd-logind' do
  action [:enable, :start]
end
