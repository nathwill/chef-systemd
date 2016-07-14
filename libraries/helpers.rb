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
      IO.read('/proc/modules').match(Regexp.new("^#{mod}\s"))
    end

    module_function :module_loaded?

    module Init
      # systemd makes this way too easy
      def systemd?
        File.exist?('/proc/1/comm') &&
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
