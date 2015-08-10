#
# Cookbook Name:: systemd
# Recipe:: user
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

u = node['systemd']['user']

systemd_user 'user' do
  drop_in false
  log_level u['log_level']
  log_target u['log_target']
  log_color u['log_color']
  log_location u['log_location']
  dump_core u['dump_core']
  crash_shell u['crash_shell']
  show_status u['show_status']
  crash_ch_vt u['crash_ch_vt']
  default_standard_output u['default_standard_output']
  default_standard_error u['default_standard_error']
  cpu_affinity u['cpu_affinity']
  join_controllers u['join_controllers']
  runtime_watchdog_sec u['runtime_watchdog_sec']
  shutdown_watchdog_sec u['shutdown_watchdog_sec']
  capability_bounding_set u['capability_bounding_set']
  system_call_architectures u['system_call_architectures']
  timer_slack_n_sec u['timer_slack_n_sec']
  default_timer_accuracy_sec u['default_timer_accuracy_sec']
  default_timeout_start_sec u['default_timeout_start_sec']
  default_timeout_stop_sec u['default_timeout_stop_sec']
  default_restart_sec u['default_restart_sec']
  default_start_limit_interval u['default_start_limit_interval']
  default_start_limit_burst u['default_start_limit_burst']
  default_environment u['default_environment']
  default_cpu_accounting u['default_cpu_accounting']
  default_block_io_accounting u['default_block_io_accounting']
  default_memory_accounting u['default_memory_accounting']
  default_limit_cpu u['default_limit_cpu']
  default_limit_fsize u['default_limit_fsize']
  default_limit_data u['default_limit_data']
  default_limit_stack u['default_limit_stack']
  default_limit_core u['default_limit_core']
  default_limit_rss u['default_limit_rss']
  default_limit_nofile u['default_limit_nofile']
  default_limit_as u['default_limit_as']
  default_limit_nproc u['default_limit_nproc']
  default_limit_memlock u['default_limit_memlock']
  default_limit_locks u['default_limit_locks']
  default_limit_sigpending u['default_limit_sigpending']
  default_limit_msgqueue u['default_limit_msgqueue']
  default_limit_nice u['default_limit_nice']
  default_limit_rtprio u['default_limit_rtprio']
  default_limit_rttime u['default_limit_rttime']
end
