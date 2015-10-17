#
# Cookbook Name:: systemd
# Recipe:: resolved
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

systemd_resolved 'resolved' do
  drop_in false
  node['systemd']['resolved'].each_pair do |config, value|
    send(config.to_sym, value) unless value.nil?
  end
  notifies :restart, 'service[systemd-resolved]', :delayed
end

service 'systemd-resolved' do
  action [:enable, :start]
end
