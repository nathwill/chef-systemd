#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdSysctl
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

require 'chef/resource/lwrp_base'
require 'chef/provider/lwrp_base'
require 'mixlib/shellout'

class Chef::Resource
  # resource for configuring kernel parameters at boot
  # http://man7.org/linux/man-pages/man5/sysctl.d.5.html
  class SystemdSysctl < Chef::Resource::LWRPBase
    self.resource_name = :systemd_sysctl

    provides :systemd_sysctl

    actions :create, :delete, :apply
    default_action :create

    attribute :value, kind_of: [String, Numeric, Array], required: true

    def to_kv
      "#{name}=#{Array(value).join(' ')}"
    end
  end
end

class Chef::Provider
  class SystemdSysctl < Chef::Provider::LWRPBase
    DIR ||= '/etc/sysctl.d'

    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_sysctl

    %i( create delete ).each do |a|
      action a do
        r = new_resource

        f = file ::File.join(DIR, "#{r.name}.conf") do
          content r.to_kv
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end

    action :apply do
      r = new_resource

      current = Mixlib::ShellOut.new("sysctl -n #{r.name}")
                .tap(&:run_command).stdout.chomp

      e = execute "sysctl -e -w #{r.to_kv}" do
        only_if { current == r.value }
      end

      new_resource.updated_by_last_action(e.updated_by_last_action?)
    end
  end
end
