#
# Cookbook Name:: systemd
# Library:: Chef::Provider::SystemdTmpfile
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
  class SystemdTmpfile < Chef::Provider::LWRPBase
    DIR ||= '/etc/tmpfiles.d'

    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_tmpfile

    action :create do
      r = new_resource

      path = ::File.join(DIR, "#{r.name}.conf")

      execute "systemd-tmpfiles --create #{path}" do
        action :nothing
        subscribes :run, "file[#{path}]", :immediately
      end

      f = file path do
        content [
          r.type, r.path, r.mode, r.uid, r.gid, r.age, r.argument
        ].join(' ')
      end

      new_resource.updated_by_last_action(f.updated_by_last_action?)
    end

    action :delete do
      r = new_resource

      path = ::File.join(DIR, "#{r.name}.conf")

      execute "systemd-tmpfiles --clean --remove #{path}" do
        only_if { ::File.exist?(path) }
      end

      f = file path do
        action :delete
      end

      new_resource.updated_by_last_action(f.updated_by_last_action?)
    end
  end
end
