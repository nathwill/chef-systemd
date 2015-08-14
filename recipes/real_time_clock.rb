#
# Cookbook Name:: systemd
# Recipe:: real_time_clock
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

rtc = node['systemd']['real_time_clock']

mode = case rtc['mode']
       when 'utc'
         0
       when 'local'
         1
       else
         Chef::Application.fatal! 'Unknown RTC mode!'
       end

cmd = ['timedatectl']
cmd << '--adjust-system-clock' if rtc['adjust_system_clock']
cmd << "set-local-rtc #{mode}"

execute cmd.join(' ') do
  not_if { Systemd::Helpers::RTC.rtc_mode?(rtc['mode']) }
end
