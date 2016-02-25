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
require_relative 'mixins'

class Chef::Resource
  class SystemdRun < Chef::Resource::LWRPBase
    include Chef::Mixin::ParamsValidate
    include Systemd::Mixin::DirectiveConversion

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

    Systemd::Run::BOOLEANS.map(&:to_sym).each do |a|
      attribute a, kind_of: [TrueClass, FalseClass], default: false
    end

    Systemd::Run::STRINGS.each do |a|
      attribute a.to_sym
    end

    Systemd::Run::ON_SECS.each do |k, v|
      attribute k.underscore.to_sym, v
    end

    attribute :service_type, Systemd::Service::OPTIONS['Type']
    attribute :setenv, Systemd::Exec::OPTIONS['Environment']
    attribute :timer_property, kind_of: Hash, default: {}

    option_attributes Systemd::Run::OPTIONS

    # rubocop: disable AbcSize
    # rubocop: disable MethodLength
    def cli_opts
      cmd = %w( systemd-run )
      cmd << "--service-type=#{send(:service_type)}" if send(:service_type)

      Systemd::Run::BOOLEANS.each do |a|
        cmd << "--#{a.tr('_', '-')}" if send(a.to_sym)
      end

      %w( STRINGS ON_SECS ).each do |c|
        Systemd::Run.const_get(c).map(&:to_sym).each do |a|
          cmd << "--#{a.to_s.tr('_', '-')}='#{send(a)}'" unless send(a).nil?
        end
      end

      %w( setenv timer_property ).map(&:to_sym).each do |a|
        send(a).each_pair { |k, v| cmd << "--#{a.tr('_', '-')}=#{k}=#{v}" }
      end

      cmd << options_config(Systemd::Run::OPTIONS).map { |o| "-p '#{o}'" }
    end
    # rubocop: enable AbcSize
    # rubocop: enable MethodLength
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
        command "systemd-run #{r.cli_opts} '#{r.command}'"
      end
    end
  end
end
