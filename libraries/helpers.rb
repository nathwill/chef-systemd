#
# Cookbook Name:: systemd
# Library:: Systemd::Helpers
#
# Copyright 2016 The Authors
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

require 'mixlib/shellout'

module Systemd
  module Helpers
    def module_loaded?(mod)
      File.exist?('/proc/modules') &&
        File.read('/proc/modules')
            .match(Regexp.new("^#{mod}\s"))
    end

    def systemd_is_pid_1?
      File.exist?('/proc/1/comm') &&
        IO.read('/proc/1/comm').chomp == 'systemd'
    end

    def rtc_mode?(lu)
      yn = lu == 'local' ? 'yes' : 'no'
      unless defined?(ChefSpec)
        Mixlib::ShellOut.new('timedatectl')
                        .tap(&:run_command)
                        .stdout
                        .match(Regexp.new("RTC in local TZ: #{yn}"))
      end
    end

    def timezone?(tz)
      File.symlink?('/etc/localtime') &&
        File.readlink('/etc/localtime').match(Regexp.new("#{tz}$"))
    end

    def build_unit_resource(type)
      @unit_type = type.to_sym

      resource_name "systemd_#{type}".to_sym
      provides "systemd_#{type}".to_sym

      option_properties Systemd.get_const(type.camelcase.to_sym)::OPTIONS

      define_method(type.to_sym) { |&block| yield }

      default_action :create

      Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
        action actn do
          systemd_unit "#{new_resource.name}.#{@unit_type}" do
            triggers_reload new_resource.triggers_reload
            content property_hash(Systemd.get_const(type.camelcase.to_sym)::OPTIONS)
            action actn
          end
        end
      end
    end

    def build_drop_in_resource(type)
      @unit_type = type.to_sym

      resource_name "systemd_#{type}_drop_in".to_sym
      provides "systemd_#{type}_drop_in".to_sym

      option_properties Systemd.const_get(type.camelcase.to_sym)::OPTIONS
      property :override, String, required: true, callbacks: {
        'matches drop-in type' => ->(s) { s.end_with?(@unit_type) }
      }

      define_method(type.to_sym) { |&block| yield }

      default_action :create

      %w( create delete ).map(&:to_sym).each do |actn|
        action actn do
          r = new_resource

          conf_d = "/etc/systemd/system/#{r.override}.d"

          directory conf_d do
            not_if { r.action == :delete }
          end

          u = systemd_unit "#{r.override}_drop-in_#{r.name}" do
            content property_hash(Systemd.const_get(@unit_type.camelcase.to_sym)::OPTIONS)
            action :nothing
          end

          execute 'systemctl daemon-reload' do
            action :nothing
            only_if { r.triggers_reload }
          end

          file "#{conf_d}/#{r.name}.conf" do
            content u.to_ini
            action actn
            notifies :run, 'execute[systemctl daemon-reload]', :immediately
          end
        end
      end
    end
    module_function :module_loaded?, :systemd_is_pid_1?, :rtc_mode?, :timezone?,
                    :build_unit_resource, :build_drop_in_resource
  end
end

class String
  def underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end

  def camelcase
    gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }
  end
end

class Hash
  def to_kv_pairs
    reject! { |_, v| v.nil? }
    map { |k, v| "#{k}=\"#{v}\"" }
  end
end
