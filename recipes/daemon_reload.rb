#
# Cookbook Name:: systemd
# Recipe:: daemon_reload
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

# In combination with `auto_reload false`, this is useful for
# managing large numbers of units, where it is otherwise too
# expensive to run a daemon-reload on every resource change.
if Chef::VERSION.to_f >= 12.5
  Chef.event_handler do
    on :converge_complete do
      SystemdHandlers::DaemonReload.new.conditionally_reload(Chef.run_context)
    end
  end
else
  ruby_block 'conditional-systemd-daemon-reload' do
    block do
      SystemdHandlers::DaemonReload.new.conditionally_reload(run_context)
    end
    action :nothing
  end

  ruby_block 'notify-delayed-conditional-systemd-daemon-reload' do
    block do
      Chef::Log.info('Triggering delayed daemon-reload evaluation.')
    end
    notifies :run, 'ruby_block[conditional-systemd-daemon-reload]', :delayed
    action :run
  end
end
