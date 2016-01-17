#
# Cookbook Name:: systemd
# Attributes:: user
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

# Ref: http://www.freedesktop.org/software/systemd/man/systemd-system.conf.html
default['systemd']['user'].tap do |u|
  u['log_level'] = nil
  u['log_target'] = nil
  u['log_color'] = nil
  u['log_location'] = nil
  u['dump_core'] = nil
  u['crash_shell'] = nil
  u['show_status'] = nil
  u['crash_ch_vt'] = nil
  u['default_standard_output'] = nil
  u['default_standard_error'] = nil
  u['cpu_affinity'] = nil
  u['join_controllers'] = nil
  u['runtime_watchdog_sec'] = nil
  u['shutdown_watchdog_sec'] = nil
  u['capability_bounding_set'] = nil
  u['system_call_architectures'] = nil
  u['timer_slack_n_sec'] = nil
  u['default_timer_accuracy_sec'] = nil
  u['default_timeout_start_sec'] = nil
  u['default_timeout_stop_sec'] = nil
  u['default_restart_sec'] = nil
  u['default_start_limit_interval'] = nil
  u['default_start_limit_burst'] = nil
  u['default_environment'] = nil
  u['default_cpu_accounting'] = nil
  u['default_block_io_accounting'] = nil
  u['default_memory_accounting'] = nil
  u['default_limit_cpu'] = nil
  u['default_limit_fsize'] = nil
  u['default_limit_data'] = nil
  u['default_limit_stack'] = nil
  u['default_limit_core'] = nil
  u['default_limit_rss'] = nil
  u['default_limit_nofile'] = nil
  u['default_limit_as'] = nil
  u['default_limit_nproc'] = nil
  u['default_limit_memlock'] = nil
  u['default_limit_locks'] = nil
  u['default_limit_sigpending'] = nil
  u['default_limit_msgqueue'] = nil
  u['default_limit_nice'] = nil
  u['default_limit_rtprio'] = nil
  u['default_limit_rttime'] = nil
end
