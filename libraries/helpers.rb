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

    def systemd?
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

    module_function :module_loaded?, :systemd?, :rtc_mode?, :timezone?
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
