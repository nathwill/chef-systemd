#
# Cookbook Name:: systemd
# Attributes:: sleep
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

# Ref: http://www.freedesktop.org/software/systemd/man/systemd-sleep.conf.html
default['systemd']['sleep'].tap do |s|
  s['suspend_mode'] = nil
  s['hibernate_mode'] = nil
  s['hybrid_sleep_mode'] = nil
  s['suspend_state'] = nil
  s['hibernate_state'] = nil
  s['hybrid_sleep_state'] = nil
end
