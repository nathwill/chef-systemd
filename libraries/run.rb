#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdRun
# Library:: Chef::Provider::SystemdRun
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
  class SystemdRun < Chef::Resource::LWRPBase
    include Chef::Mixin::ParamsValidate

    resource_name :systemd_run
    identity_attr :command

    actions :run
    default_action :run

    def command(arg = nil)
      set_or_return(
        :command, arg,
        kind_of: String,
        default: name
      )
    end

    attribute :unit, kind_of: String
    attribute :slice, kind_of: String

    %w( scope no_block send_sighup pty ).map(&:to_sym).each do |a|
      attribute a, kind_of: [TrueClass, FalseClass], default: false
    end

    option_attributes Systemd::Exec::OPTIONS
    option_attributes Systemd::Kill::OPTIONS
    option_attributes Systemd::ResourceControl::OPTIONS
    option_attributes Systemd::Timer::OPTIONS

    def cli_opts

    end
  end
end

class Chef::Provider
  class SystemdRun < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_run if defined?(provides)

    action :run do
      r = new_resource

      execute "systemd_run-#{r.name}" do
        command "systemd-run #{r.cli_opts} #{r.command}"
      end
    end
  end
end
