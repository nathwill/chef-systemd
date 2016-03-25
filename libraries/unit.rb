#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdUnit
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

require 'chef/mixin/params_validate'
require 'mixlib/shellout'
require_relative 'systemd'
require_relative 'helpers'
require_relative 'conf'

class ChefSystemdCookbook
  # base class for systemd unit resources
  # http://www.freedesktop.org/software/systemd/man/systemd.unit.html
  class UnitResource < ChefSystemdCookbook::ConfResource
    include Chef::Mixin::ParamsValidate

    resource_name :systemd_unit

    actions :create, :delete, :enable, :disable, :reload, :restart,
            :start, :stop, :mask, :unmask, :set_properties

    attribute :auto_reload, kind_of: [TrueClass, FalseClass], default: true
    attribute :aliases, kind_of: Array, default: []
    attribute :overrides, kind_of: Array, default: []
    attribute :conf_type, kind_of: Symbol, required: true,
                          equal_to: Systemd::Helpers::UNITS
    attribute :mode, kind_of: Symbol, default: :system,
                     equal_to: %w( system user ).map(&:to_sym)

    # it doesn't make sense to perform lifecycle actions
    # against drop-in units, so limit their allowed actions
    def action(arg = nil)
      if drop_in
        @allowed_actions = %w( create delete set_properties ).map(&:to_sym)
      elsif conf_type == :target
        @allowed_actions << :set_default
      end

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

    # units have multiple sections, so override the base class
    # method to produce a suitable hash for ini generation
    def to_hash
      conf = {}

      [:unit, :install, conf_type].each do |section|
        # some unit types don't have type-specific config blocks
        next if Systemd::Helpers::STUB_UNITS.include?(section)
        conf[section] = section_values(section)
      end

      conf
    end

    alias to_h to_hash

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

  class UnitProvider < ChefSystemdCookbook::ConfProvider
    provides :systemd_unit if defined?(provides)
    Systemd::Helpers::UNITS.reject { |u| u == :target }.each do |unit_type|
      provides "systemd_#{unit_type}".to_sym if defined?(provides)
    end

    %w(
      enable disable start stop restart reload mask unmask
    ).map(&:to_sym).each do |a|
      action a do
        r = new_resource

        unless defined?(ChefSpec)
          state = case a
                  when :enable, :disable, :mask, :unmask
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
                  when :restart, :reload
                    false
                  when :mask
                    %w( masked masked-runtime ).include? state
                  when :unmask
                    !%w( masked masked-runtime ).include? state
                  end
        end

        e = execute "systemctl #{a} #{r.name}.#{r.conf_type}" do
          not_if { match }
        end

        new_resource.updated_by_last_action(e.updated_by_last_action?)
      end
    end

    action :set_properties do
      r = new_resource

      props = r.to_hash.values.flatten
      args = props.unshift("#{r.drop_in ? r.override : r.name}.#{r.conf_type}")

      execute "systemctl --runtime set-property #{args.join(' ')}"
    end
  end
end
