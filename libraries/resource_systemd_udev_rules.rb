#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdUdevRules
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

class Chef::Resource
  class SystemdUdevRules < Chef::Resource::LWRPBase
    self.resource_name = :systemd_udev_rules
    provides :systemd_udev_rules

    actions :create, :delete, :disable
    default_action :create

    attribute :rules, kind_of: Array, default: [], callbacks: {
      'is a valid rule set' => lambda do |specs|
        specs.is_a?(Array) && specs.all? do |spec|
          spec.is_a?(Array) && spec.all? do |rule|
            rule.length == 3 &&
              rule.keys.all? { |k| %w( key operator value ).include? k } &&
              %w(
                ACTION DEVPATH KERNEL NAME SUBSYSTEM DRIVER OPTIONS
                SYMLINK ATTR SYSCTL ENV TEST PROGRAM RESULT IMPORT
                NAME OWNER GROUP MODE SECLABEL RUN LABEL GOTO TAG
              ).any? { |k| rule['key'].start_with? k } &&
              %w( == != = += -= := ).include?(rule['operator'])
          end
        end
      end
    }

    def to_s
      send(:rules).map do |rules|
        rules.map do |rule|
          "#{rule['key']}#{rule['operator']}\"#{rule['value']}\""
        end.join(', ')
      end.join("\n")
    end
  end
end
