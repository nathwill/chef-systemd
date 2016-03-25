#
# Cookbook Name:: systemd
# Library:: HandlerSystemdDaemonReload
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
#

# Event-handler actions
# Ref: https://docs.chef.io/handlers.html#event-handlers
require 'chef/resource/execute'

module SystemdHandlers
  class DaemonReload
    def conditionally_reload(run_context)
      reload_disabled = run_context.resource_collection.select do |r|
        r.is_a?(ChefSystemdCookbook::UnitResource) && r.auto_reload == false
      end

      if reload_disabled.any?(&:updated_by_last_action?)
        Chef::Resource::Execute.new('systemctl daemon-reload', run_context)
                               .run_action(:run)
      end
    end
  end
end
