#
# Cookbook Name:: systemd
# Recipe:: journald
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

j = node['systemd']['journald']

systemd_journald 'journald' do
  storage j['storage']
  compress j['compress']
  seal j['seal']
  split_mode j['split_mode']
  rate_limit_interval j['rate_limit_interval']
  rate_limit_burst j['rate_limit_burst']
  system_max_use j['system_max_use']
  system_keep_free j['system_keep_free']
  system_max_file_size j['system_max_file_size']
  runtime_max_use j['runtime_max_use']
  runtime_keep_free j['runtime_keep_free']
  runtime_max_file_size j['runtime_max_file_size']
  max_file_sec j['max_file_sec']
  max_retention_sec j['max_retention_sec']
  sync_interval_sec j['sync_interval_sec']
  forward_to_syslog j['forward_to_syslog']
  forward_to_k_msg j['forward_to_k_msg']
  forward_to_console j['forward_to_console']
  forward_to_wall j['forward_to_wall']
  max_level_store j['max_level_store']
  max_level_syslog j['max_level_syslog']
  max_level_k_msg j['max_level_k_msg']
  max_level_console j['max_level_console']
  max_level_wall j['max_level_wall']
  tty_path j['tty_path']
  notifies :restart, 'service[systemd-journald]', :delayed
end

service 'systemd-journald' do
  action [:enable, :start]
end
