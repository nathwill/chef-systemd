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

class ChefSystemdCookbook
  class SystemdRunResource < Chef::Resource::LWRPBase
    include Chef::Mixin::ParamsValidate
    include Systemd::Mixin::DirectiveConversion

    resource_name :systemd_run
    identity_attr :unit

    actions :run, :stop
    default_action :run

    def unit(arg = nil)
      set_or_return(
        :unit, arg,
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

    Systemd::Run::ON_SECS.each do |a|
      attribute a.underscore.to_sym, kind_of: [String, Integer]
    end

    attribute :command, kind_of: String, required: true
    attribute :service_type, Systemd::Service::OPTIONS['Type']
    attribute :setenv, kind_of: Hash, default: {}
    attribute :timer_property, kind_of: Hash, default: {}

    option_attributes Systemd::Run::OPTIONS

    # rubocop: disable AbcSize
    # rubocop: disable MethodLength
    def cli_opts
      cmd = ["--unit=#{send(:unit)}"]

      cmd << "--service-type=#{send(:service_type)}" if send(:service_type)

      Systemd::Run::BOOLEANS.each do |a|
        cmd << "--#{a.tr('_', '-')}" if send(a.to_sym)
      end

      %w( STRINGS ON_SECS ).each do |c|
        Systemd::Run.const_get(c).map(&:to_sym).each do |a|
          cmd << "--#{a.to_s.tr('_', '-')}='#{send(a)}'" unless send(a).nil?
        end
      end

      %w( setenv timer_property ).each do |a|
        send(a.to_sym).each_pair do |k, v|
          cmd << "--#{a.tr('_', '-')}=#{k}=#{v}"
        end
      end

      cmd << options_config(Systemd::Run::OPTIONS).map { |o| "-p '#{o}'" }

      cmd.flatten.join(' ')
    end
    # rubocop: enable AbcSize
    # rubocop: enable MethodLength
  end

  class SystemdRunProvider < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    def active?(unit)
      Mixlib::ShellOut.new("systemctl is-active #{unit}")
                      .tap(&:run_command)
                      .stdout
                      .chomp == 'active'
    end

    provides :systemd_run if defined?(provides)

    action :run do
      r = new_resource

      cmd = "systemd-run #{r.cli_opts} #{r.command}"
      stop = "systemctl stop #{r.unit}"

      execute stop do
        action :nothing
        only_if { active?(r.unit) }
      end

      file "/var/cache/#{r.unit}" do
        content cmd
        notifies :run, "execute[#{stop}]", :immediately
      end

      e = execute cmd do
        not_if { active?(r.unit) }
      end

      r.updated_by_last_action(e.updated_by_last_action?)
    end

    action :stop do
      r = new_resource

      e = execute "systemctl stop #{r.unit}" do
        only_if { active?(r.unit) }
      end

      r.updated_by_last_action(e.updated_by_last_action?)
    end
  end
end
