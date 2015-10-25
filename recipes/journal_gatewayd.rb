#
# Cookbook Name:: systemd
# Recipe:: journal_gatewayd
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

jg = node['systemd']['journal_gatewayd']

package jg['package']

systemd_socket 'local-journal-gatewayd-listen-stream' do
  drop_in true
  override 'systemd-journal-gatewayd'
  overrides %w( ListenStream )
  listen_stream jg['listen_stream'] unless jg['listen_stream'].nil?
  only_if { jg['listen_stream'] }
  notifies :restart, 'systemd_socket[systemd-journal-gatewayd]', :delayed
end

opts = jg['options'].reject { |_, v| v.nil? }.map do |o, v|
  "--#{o}=#{v}"
end

systemd_service 'local-journal-gatewayd-options' do
  drop_in true
  override 'systemd-journal-gatewayd'
  overrides %w( ExecStart )
  service do
    exec_start "/usr/lib/systemd/systemd-journal-gatewayd #{opts.join(' ')}"
  end
  not_if { opts.empty? }
  notifies :stop, 'service[systemd-journal-gatewayd]', :delayed
end

systemd_socket 'systemd-journal-gatewayd' do
  action [:enable, :start]
end

service 'systemd-journal-gatewayd' do
  action :nothing
end
