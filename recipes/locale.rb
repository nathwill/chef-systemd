#
# Cookbook Name:: systemd
# Recipe:: locale
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

l = node['systemd']['locale']

opts = l.reject { |_, v| v.nil? }

file '/etc/locale.conf' do
  content opts.map { |k, v| "#{k.upcase}=\"#{v}\"" }.join("\n")
  not_if { opts.empty? }
  notifies :restart, 'service[systemd-localed]', :immediately
end

service 'systemd-localed' do
  action :enable
end
