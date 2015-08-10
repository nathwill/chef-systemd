#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdUnit
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

require 'chef/mixin/params_validate'
require_relative 'resource_systemd_conf'
require_relative 'systemd_install'
require_relative 'systemd_unit'
require_relative 'helpers'

class Chef::Resource
  class SystemdUnit < Chef::Resource::SystemdConf
    include Chef::Mixin::ParamsValidate

    self.resource_name = :systemd_unit
    provides :systemd_unit

    actions :create, :delete, :enable, :disable, :start, :stop, :restart

    attribute :aliases, kind_of: Array, default: []
    attribute :overrides, kind_of: Array, default: []
    attribute :conf_type, kind_of: Symbol, required: true, default: :service,
                          equal_to: Systemd::Helpers::UNITS
    attribute :mode, kind_of: Symbol, default: :system,
                     equal_to: %i( system user )

    def action(arg = nil)
      @allowed_actions = %i( create delete ) if drop_in
      super
    end

    def drop_in(arg = nil)
      set_or_return(
        :drop_in, arg,
        kind_of: [TrueClass, FalseClass],
        default: false
      )
    end

    def override(arg = nil)
      set_or_return(
        :override, arg,
        kind_of: String,
        default: nil,
        required: drop_in
      )
    end

    %w( unit install ).each do |section|
      # convert the section options to resource attributes
      option_attributes Systemd.const_get(section.capitalize)::OPTIONS
    end

    # useful for grouping install-section attributes
    def install
      yield
    end

    def to_hash
      conf = {}

      [:unit, :install, conf_type].each do |section|
        # some unit types don't have type-specific config blocks
        next if Systemd::Helpers::STUB_UNITS.include?(section)
        conf[section] = section_values(section)
      end

      conf
    end

    alias_method :to_h, :to_hash

    private

    def section_values(section)
      opts = Systemd.const_get(section.capitalize)::OPTIONS

      [].concat overrides_config(section, opts)
        .concat alias_config(section)
        .concat options_config(opts)
    end

    def overrides_config(section, opts)
      return [] unless drop_in

      section_overrides = overrides.select do |o|
        opts.include?(o) || (section == :install && o == 'Alias')
      end

      section_overrides.map do |over_ride|
        "#{over_ride}="
      end
    end

    def alias_config(section)
      return [] unless section == :install && !aliases.empty?
      ["Alias=#{aliases.map { |a| "#{a}.#{conf_type}" }.join(' ')}"]
    end
  end
end
