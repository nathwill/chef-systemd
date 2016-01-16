#
# Cookbook Name:: systemd
# Attributes:: logind
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

# Ref: http://www.freedesktop.org/software/systemd/man/logind.conf.html
default['systemd']['logind'].tap do |l|
  l['n_auto_v_ts'] = 0
  l['reserve_vt'] = nil
  l['kill_user_processes'] = nil
  l['kill_only_users'] = nil
  l['kill_exclude_users'] = nil
  l['idle_action'] = nil
  l['idle_action_sec'] = nil
  l['inhibit_delay_max_sec'] = nil
  l['handle_power_key'] = nil
  l['handle_suspend_key'] = nil
  l['handle_hibernate_key'] = nil
  l['handle_lid_switch'] = nil
  l['handle_lid_switch_docked'] = nil
  l['power_key_ignore_inhibited'] = nil
  l['suspend_key_ignore_inhibited'] = nil
  l['hibernate_key_ignore_inhibited'] = nil
  l['lid_switch_ignore_inhibited'] = nil
  l['holdoff_timeout_sec'] = nil
  l['runtime_directory_size'] = nil
  l['remove_ipc'] = nil
end
