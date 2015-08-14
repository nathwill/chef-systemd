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
    DAEMONS ||= %i( journald logind resolved timesyncd )

    UTILS ||= %i( bootchart coredump sleep system user )

    STUB_UNITS ||= %i( device target )

    UNITS ||= %i(
      service socket device mount automount
      swap target path timer slice
    )

    def ini_config(conf = {})
      conf.delete_if { |_, v| v.empty? }.map do |section, params|
        "[#{section.capitalize}]\n#{params.join("\n")}\n"
      end.join("\n")
    end

    def local_conf_root
      '/etc/systemd'
    end

    def unit_conf_root(conf)
      ::File.join(local_conf_root, conf.mode.to_s)
    end

    def conf_drop_in_root(conf)
      if conf.is_a?(Chef::Resource::SystemdUnit)
        ::File.join(
          unit_conf_root(conf),
          "#{conf.override}.#{conf.conf_type}.d"
        )
      else
        ::File.join(local_conf_root, "#{conf.conf_type}.conf.d")
      end
    end

    def conf_path(conf)
      if conf.drop_in
        ::File.join(conf_drop_in_root(conf), "#{conf.name}.conf")
      else
        if conf.is_a?(Chef::Resource::SystemdUnit)
          ::File.join(unit_conf_root(conf), "#{conf.name}.#{conf.conf_type}")
        else
          ::File.join(local_conf_root, "#{conf.conf_type}.conf")
        end
      end
    end

    module_function :ini_config, :local_conf_root, :unit_conf_root,
                    :conf_drop_in_root, :conf_path

    module Init
      def systemd?
        IO.read('/proc/1/comm').chomp == 'systemd'
      end
    end

    module NTP
      def ntp_abled?(yn)
        Mixlib::ShellOut.new('timedatectl')
          .tap(&:run_command)
          .stdout
          .match(Regexp.new("NTP enabled: #{yn}")) unless defined?(ChefSpec)
      end

      module_function :ntp_abled?
    end

    module RTC
      def rtc_mode?(lu)
        yn = lu == 'local' ? 'yes' : 'no'
        Mixlib::ShellOut.new('timedatectl')
          .tap(&:run_command)
          .stdout
          .match(Regexp.new("RTC in local TZ: #{yn}")) unless defined?(ChefSpec)
      end

      module_function :rtc_mode?
    end
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

  def camelize
    gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }
  end
end

::Chef::Recipe.send(:include, Systemd::Helpers::Init)
