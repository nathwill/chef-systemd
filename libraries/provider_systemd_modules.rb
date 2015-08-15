#
# Cookbook Name:: systemd
# Library:: Chef::Provider::SystemdModules
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
  class SystemdModules < Chef::Provider::LWRPBase
    DIR ||= '/etc/modules-load.d'

    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_modules

    %i( create delete ).each do |a|
      action a do
        r = new_resource

        path = ::File.join(DIR, "#{r.name}.conf")

        f = file path do
          content r.modules.join("\n")
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end

    action :load do
      r = new_resource

      updated = []

      r.modules.each do |m|
        e = execute "modprobe #{m}" do
          not_if { IO.read('/proc/modules').match(Regexp.new("^#{m}\s")) }
        end

        updated << m if e.updated_by_last_action?
      end

      new_resource.updated_by_last_action(!updated.empty?)
    end

    action :unload do
      r = new_resource

      updated = []

      r.modules.each do |m|
        e = execute "modprobe -r #{m}" do
          only_if { IO.read('/proc/modules').match(Regexp.new("^#{m}\s")) }
        end

        updated << m if e.updated_by_last_action?
      end

      new_resource.updated_by_last_action(!updated.empty?)
    end
  end
end
