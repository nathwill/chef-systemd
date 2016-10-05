#
# Cookbook Name:: systemd
# Library:: SystemdCookbook::Helpers
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

module SystemdCookbook
  module Helpers
    def module_loaded?(mod)
      File.exist?('/proc/modules') &&
        !(File.read('/proc/modules') !~ Regexp.new("^#{mod}\s"))
    end

    def systemd_is_pid_1?
      File.exist?('/proc/1/comm') &&
        File.read('/proc/1/comm').chomp == 'systemd'
    end

    module_function :module_loaded?, :systemd_is_pid_1?
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
    reject { |_, v| v.nil? }
      .map { |k, v| "#{k}=\"#{v}\"" }
  end
end
