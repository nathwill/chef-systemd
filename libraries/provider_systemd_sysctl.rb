#
# Cookbook Name:: systemd
# Library:: Chef::Provider::SystemdSysctl
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

require 'chef/provider/lwrp_base'

class Chef::Provider
  class SystemdSysctl < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_sysctl

    %i( create delete ).each do |a|
      action a do
        r = new_resource
        dir = '/etc/sysctl.d'

        f = file ::File.join(dir, "#{r.name}.conf") do
          content "#{r.name}=#{r.value}"
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
