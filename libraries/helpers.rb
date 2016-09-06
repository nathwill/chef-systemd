#
# Cookbook Name:: systemd
# Library:: Systemd::Helpers
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

require 'mixlib/shellout'
require 'chef/resource'
require 'chef/recipe'

module Systemd
  module Helpers
    # list of supported systemd daemons
    DAEMONS ||= %w( journald logind resolved timesyncd ).map(&:to_sym)

    # list of supported systemd utilities
    UTILS ||= %w( bootchart coredump sleep system user ).map(&:to_sym)

    # unit types without dedicated configuration options
    STUB_UNITS ||= %w( target netdev network device ).map(&:to_sym)

    # list of supported unit types
    UNITS ||= %w(
      service socket mount automount
      swap target path timer slice
    ).map(&:to_sym)

    # converts hash to ini-formatted string
    def ini_config(conf = {})
      conf.delete_if { |_, v| v.empty? }.map do |section, params|
        "[#{section.capitalize}]\n#{params.join("\n")}\n"
      end.join("\n")
    end

    # systemd's administrator-managed load path. leave /usr/lib
    # for the vendors to use, the way god^wlennart intended ;)
    def local_conf_root
      '/etc/systemd'
    end

    # path for systemd units (varies by systemd mode (user, system))
    def unit_conf_root(conf)
      ::File.join(local_conf_root, conf.mode.to_s)
    end

    # path for drop-in configuration of systemd resources
    def conf_drop_in_root(conf)
      if conf.is_a?(ChefSystemdCookbook::UnitResource)
        ::File.join(
          unit_conf_root(conf),
          "#{conf.override}.#{conf.conf_type}.d"
        )
      else
        ::File.join(local_conf_root, "#{conf.conf_type}.conf.d")
      end
    end

    # Full path for rendered resource config file
    def conf_path(conf)
      if conf.drop_in
        ::File.join(conf_drop_in_root(conf), "#{conf.name}.conf")
      elsif conf.is_a?(ChefSystemdCookbook::UnitResource)
        ::File.join(unit_conf_root(conf), "#{conf.name}.#{conf.conf_type}")
      else
        ::File.join(local_conf_root, "#{conf.conf_type}.conf")
      end
    end

    def module_loaded?(mod)
      IO.read('/proc/modules').match(Regexp.new("^#{mod}\s"))
    end

    module_function :ini_config, :local_conf_root, :unit_conf_root,
                    :conf_drop_in_root, :conf_path, :module_loaded?

    module Init
      # systemd makes this way too easy
      def systemd?
        IO.read('/proc/1/comm').chomp == 'systemd'
      end
    end

    module RTC
      # ascertain if current real-time-clock mode (utc/local) matches argument
      def rtc_mode?(lu)
        yn = lu == 'local' ? 'yes' : 'no'
        unless defined?(ChefSpec)
          Mixlib::ShellOut.new('timedatectl')
                          .tap(&:run_command)
                          .stdout
                          .match(Regexp.new("RTC in local TZ: #{yn}"))
        end
      end

      module_function :rtc_mode?
    end

    module Timezone
      # ascertain if current timezone matches argument
      def timezone?(tz)
        File.symlink?('/etc/localtime') &&
          File.readlink('/etc/localtime').match(Regexp.new("#{tz}$"))
      end

      module_function :timezone?
    end
  end
end

class String
  # converts camel-cased config directives to snake_cased attribute names
  def underscore
    gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .tr('-', '_')
      .downcase
  end

  # converts snake_cased attribute names to camel-cased config directives
  def camelize
    gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }
  end
end
