#
# Cookbook Name:: systemd
# Recipe:: daemon_reload_notify
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

# You can send your notifications here for `auto_reload false`
# units, but if you're using Chef >= 12.5, you should use the 
# event handler in daemon_reload_handler recipe instead.
execute 'systemctl daemon-reload' do
  action :nothing
end
