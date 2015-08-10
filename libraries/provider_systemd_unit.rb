#
# Cookbook Name:: systemd
# Library:: Chef::Provider::SystemdUnit
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

require_relative 'provider_systemd_conf'
require 'mixlib/shellout'

class Chef::Provider
  class SystemdUnit < Chef::Provider::SystemdConf
    provides :systemd_unit
    Systemd::Helpers::UNITS.each do |unit_type|
      provides "systemd_#{unit_type}".to_sym
    end

    %i( enable disable start stop restart ).each do |a|
      action a do
        r = new_resource

        unless defined?(ChefSpec)
          state = case a
                  when :enable, :disable
                    Mixlib::ShellOut.new(
                      "systemctl is-enabled #{r.name}.#{r.conf_type}"
                    ).tap(&:run_command).stdout.chomp
                  when :start, :stop
                    Mixlib::ShellOut.new(
                      "systemctl is-active #{r.name}.#{r.conf_type}"
                    ).tap(&:run_command).stdout.chomp
                  when :restart
                    nil
                  end

          match = case a
                  when :enable
                    %w( static enabled enabled-runtime ).include? state
                  when :disable
                    %w( static disabled masked masked-runtime ).include? state
                  when :start
                    state == 'active'
                  when :stop
                    %w( inactive unknown ).include? state
                  when :restart
                    false
                  end
        end

        e = execute "systemctl #{a} #{r.name}.#{r.conf_type}" do
          not_if { match }
        end

        new_resource.updated_by_last_action(e.updated_by_last_action?)
      end
    end
  end
end
