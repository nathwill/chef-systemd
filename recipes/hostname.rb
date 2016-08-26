#
# Cookbook Name:: systemd
# Recipe:: hostname
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

hostname = node['systemd']['hostname']

# hostnamectl will populate this file
# but we write it explicitly for idempotency
file '/etc/hostname' do
  content hostname
  not_if { hostname.nil? }
  notifies :run, 'execute[set-hostname]', :immediately
end

# apply immediately; works on all platforms
execute 'set-hostname' do
  command "hostnamectl set-hostname #{hostname}"
  action :nothing
  not_if { hostname.nil? }
end
