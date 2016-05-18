#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdUdevRules
# Library:: Chef::Provider::SystemdUdevRules
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
require 'chef/resource/lwrp_base'

class ChefSystemdCookbook
  # resource for managing udev rules
  # http://www.freedesktop.org/software/systemd/man/udev.html
  class UdevRulesResource < Chef::Resource::LWRPBase
    VALID_UDEV_OPERATORS ||= %w( == != = += -= := ).freeze
    VALID_RULE_KEYS ||= %w( key operator value ).freeze
    VALID_UDEV_KEYS ||= %w(
      ACTION DEVPATH KERNEL NAME SUBSYSTEM DRIVER OPTIONS
      SYMLINK ATTR SYSCTL ENV TEST PROGRAM RESULT IMPORT
      NAME OWNER GROUP MODE SECLABEL RUN LABEL GOTO TAG
    ).freeze

    resource_name :systemd_udev_rules

    actions :create, :delete, :disable
    default_action :create

    attribute :rules, kind_of: Array, default: [], callbacks: {
      'is a valid rule set' => lambda do |specs|
        specs.is_a?(Array) && specs.all? do |spec|
          spec.is_a?(Array) && spec.all? do |rule|
            rule.length == 3 &&
              rule.keys.all? { |k| VALID_RULE_KEYS.include? k } &&
              VALID_UDEV_KEYS.any? { |k| rule['key'].start_with? k } &&
              VALID_UDEV_OPERATORS.include?(rule['operator'])
          end
        end
      end
    }

    def as_string
      rules.map do |line|
        line.map do |rule|
          "#{rule['key']}#{rule['operator']}\"#{rule['value']}\""
        end.join(', ')
      end.join("\n")
    end
  end

  class UdevRulesProvider < Chef::Provider::LWRPBase
    DIR ||= '/etc/udev/rules.d'.freeze

    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_udev_rules if defined?(provides)

    %w( create delete ).map(&:to_sym).each do |a|
      action a do
        r = new_resource

        directory DIR do
          not_if { r.action == :delete }
        end

        f = file ::File.join(DIR, "#{r.name}.rules") do
          content r.as_string
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end

    action :disable do
      r = new_resource

      rule_path = ::File.join(DIR, "#{r.name}.rules")

      file rule_path do
        action :delete
        not_if do
          ::File.symlink?(rule_path) && ::File.readlink(rule_path) == File::NULL
        end
      end

      l = link rule_path do
        to File::NULL
      end

      new_resource.updated_by_last_action(l.updated_by_last_action?)
    end
  end
end
