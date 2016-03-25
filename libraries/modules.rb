#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdModules
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

require 'chef/resource/lwrp_base'
require 'chef/provider/lwrp_base'
require_relative 'helpers'

class ChefSystemdCookbook
  # manage system modules
  # http://www.freedesktop.org/software/systemd/man/modules-load.d.html
  # http://linux.die.net/man/5/modprobe.d
  class ModulesResource < Chef::Resource::LWRPBase
    resource_name :systemd_modules

    actions :create, :delete, :load, :unload
    default_action :create

    attribute :blacklist, kind_of: [TrueClass, FalseClass], default: false
    attribute :modules, kind_of: Array, default: %w(), required: true
  end

  class ModulesProvider < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_modules if defined?(provides)

    %w( create delete ).map(&:to_sym).each do |a|
      action a do
        r = new_resource

        dir = r.blacklist ? '/etc/modprobe.d' : '/etc/modules-load.d'
        mods = r.blacklist ? r.modules.map { |m| "blacklist #{m}" } : r.modules

        f = file ::File.join(dir, "#{r.name}.conf") do
          content mods.join("\n")
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
          not_if { Systemd::Helpers.module_loaded?(m) }
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
          only_if { Systemd::Helpers.module_loaded?(m) }
        end

        updated << m if e.updated_by_last_action?
      end

      new_resource.updated_by_last_action(!updated.empty?)
    end
  end
end
