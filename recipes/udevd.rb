#
# Cookbook Name:: systemd
# Recipe:: udevd
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

u = node['systemd']['udev']

file '/etc/udev/udev.conf' do
  content "udev_log=\"#{u['udev_log']}\""
  not_if { u['udev_log'].nil? }
  notifies :restart, 'service[systemd-udevd]', :immediately
end

opts = u['options'].reject { |_, v| v.nil? }.map do |o, v|
  "--#{o}=#{v}"
end

systemd_service 'local-udevd-options' do
  drop_in true
  override 'systemd-udevd'
  overrides %w( ExecStart )
  service do
    exec_start value_for_platform_family(
      'debian' => "/lib/systemd/systemd-udevd #{opts.join(' ')}",
      'default' => "/usr/lib/systemd/systemd-udevd #{opts.join(' ')}"
    )
  end
  not_if { opts.empty? }
  notifies :restart, 'service[systemd-udevd]', :delayed
end

service 'systemd-udevd' do
  action :enable
end
