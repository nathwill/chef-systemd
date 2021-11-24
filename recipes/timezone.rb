#
# Cookbook:: systemd
# Recipe:: timezone
#
# Copyright:: 2015 - 2016, The Authors
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
#
# https://www.freedesktop.org/software/systemd/man/timedatectl.html
#

ohai 'timezone' do
  plugin 'time/timezone'
  action :nothing
end

execute 'set-timezone' do
  command "timedatectl set-timezone #{node['systemd']['timezone']}"
  not_if { node['time']['timezone'] == node['systemd']['timezone'] }
  notifies :reload, 'ohai[timezone]', :immediately
end
