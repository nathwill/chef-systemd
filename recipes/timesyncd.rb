#
# Cookbook Name:: systemd
# Recipe:: timesyncd
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

ts = node['systemd']['timesyncd']

systemd_timesyncd 'timesyncd' do
  ntp ts['ntp']
  fallback_ntp ts['fallback_ntp']
  notifies :restart, 'service[systemd-timesyncd]', :delayed
end

service 'systemd-timesyncd' do
  action [:enable, :start]
end
