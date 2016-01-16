#
# Cookbook Name:: systemd
# Attributes:: journald
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

# Ref: http://www.freedesktop.org/software/systemd/man/journald.conf.html
default['systemd']['journald'].tap do |j|
  j['storage'] = 'auto'
  j['compress'] = nil
  j['seal'] = nil
  j['split_mode'] = nil
  j['rate_limit_interval'] = nil
  j['rate_limit_burst'] = nil
  j['system_max_use'] = nil
  j['system_keep_free'] = nil
  j['system_max_file_size'] = nil
  j['runtime_max_use'] = nil
  j['runtime_keep_free'] = nil
  j['runtime_max_file_size'] = nil
  j['max_file_sec'] = nil
  j['max_retention_sec'] = nil
  j['sync_interval_sec'] = nil
  j['forward_to_syslog'] = nil
  j['forward_to_k_msg'] = nil
  j['forward_to_console'] = nil
  j['forward_to_wall'] = nil
  j['max_level_store'] = nil
  j['max_level_syslog'] = nil
  j['max_level_k_msg'] = nil
  j['max_level_console'] = nil
  j['max_level_wall'] = nil
  j['tty_path'] = nil
end
