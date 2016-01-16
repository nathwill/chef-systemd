#
# Cookbook Name:: systemd
# Attributes:: system
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
default['systemd']['system'].tap do |s|
  s['log_level'] = nil
  s['log_target'] = nil
  s['log_color'] = nil
  s['log_location'] = nil
  s['dump_core'] = nil
  s['crash_shell'] = nil
  s['show_status'] = nil
  s['crash_ch_vt'] = nil
  s['default_standard_output'] = nil
  s['default_standard_error'] = nil
  s['cpu_affinity'] = nil
  s['join_controllers'] = nil
  s['runtime_watchdog_sec'] = nil
  s['shutdown_watchdog_sec'] = nil
  s['capability_bounding_set'] = nil
  s['system_call_architectures'] = nil
  s['timer_slack_n_sec'] = nil
  s['default_timer_accuracy_sec'] = nil
  s['default_timeout_start_sec'] = nil
  s['default_timeout_stop_sec'] = nil
  s['default_restart_sec'] = nil
  s['default_start_limit_interval'] = nil
  s['default_start_limit_burst'] = nil
  s['default_environment'] = nil
  s['default_cpu_accounting'] = nil
  s['default_block_io_accounting'] = nil
  s['default_memory_accounting'] = nil
  s['default_limit_cpu'] = nil
  s['default_limit_fsize'] = nil
  s['default_limit_data'] = nil
  s['default_limit_stack'] = nil
  s['default_limit_core'] = nil
  s['default_limit_rss'] = nil
  s['default_limit_nofile'] = nil
  s['default_limit_as'] = nil
  s['default_limit_nproc'] = nil
  s['default_limit_memlock'] = nil
  s['default_limit_locks'] = nil
  s['default_limit_sigpending'] = nil
  s['default_limit_msgqueue'] = nil
  s['default_limit_nice'] = nil
  s['default_limit_rtprio'] = nil
  s['default_limit_rttime'] = nil
end
