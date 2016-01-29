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

require_relative 'systemd'
require_relative 'helpers'

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

    Systemd::Run::STRINGS.each do |a|
      attribute a.to_sym
    end

    Systemd::Run::BOOLEANS.map(&:to_sym).each do |a|
      attribute a, kind_of: [TrueClass, FalseClass], default: false
    end

    Systemd::Run::ON_SECS.each do |k, v|
      attribute k.underscore.to_sym, v
    end

    attribute :service_type, Systemd::Service::OPTIONS['Type']
    attribute :nice, Systemd::Exec::OPTIONS['Nice']
    attribute :setenv, Systemd::Exec::OPTIONS['Environment']
    attribute :on_calendar, Systemd::Timer::OPTIONS['OnCalendar']
    attribute :timer_property, kind_of: Hash, default: {}

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
