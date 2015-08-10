#
# Cookbook Name:: systemd
# Recipe:: system
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

s = node['systemd']['system']

systemd_system 'system' do
  drop_in false
  log_level s['log_level']
  log_target s['log_target']
  log_color s['log_color']
  log_location s['log_location']
  dump_core s['dump_core']
  crash_shell s['crash_shell']
  show_status s['show_status']
  crash_ch_vt s['crash_ch_vt']
  default_standard_output s['default_standard_output']
  default_standard_error s['default_standard_error']
  cpu_affinity s['cpu_affinity']
  join_controllers s['join_controllers']
  runtime_watchdog_sec s['runtime_watchdog_sec']
  shutdown_watchdog_sec s['shutdown_watchdog_sec']
  capability_bounding_set s['capability_bounding_set']
  system_call_architectures s['system_call_architectures']
  timer_slack_n_sec s['timer_slack_n_sec']
  default_timer_accuracy_sec s['default_timer_accuracy_sec']
  default_timeout_start_sec s['default_timeout_start_sec']
  default_timeout_stop_sec s['default_timeout_stop_sec']
  default_restart_sec s['default_restart_sec']
  default_start_limit_interval s['default_start_limit_interval']
  default_start_limit_burst s['default_start_limit_burst']
  default_environment s['default_environment']
  default_cpu_accounting s['default_cpu_accounting']
  default_block_io_accounting s['default_block_io_accounting']
  default_memory_accounting s['default_memory_accounting']
  default_limit_cpu s['default_limit_cpu']
  default_limit_fsize s['default_limit_fsize']
  default_limit_data s['default_limit_data']
  default_limit_stack s['default_limit_stack']
  default_limit_core s['default_limit_core']
  default_limit_rss s['default_limit_rss']
  default_limit_nofile s['default_limit_nofile']
  default_limit_as s['default_limit_as']
  default_limit_nproc s['default_limit_nproc']
  default_limit_memlock s['default_limit_memlock']
  default_limit_locks s['default_limit_locks']
  default_limit_sigpending s['default_limit_sigpending']
  default_limit_msgqueue s['default_limit_msgqueue']
  default_limit_nice s['default_limit_nice']
  default_limit_rtprio s['default_limit_rtprio']
  default_limit_rttime s['default_limit_rttime']
end
