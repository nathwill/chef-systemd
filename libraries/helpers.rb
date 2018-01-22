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

  # Create a stub class for evaluating resource sub-blocks outside resource context
  class OptionEvalContext
    # parent is the parent resource
    # context is the sub-block we're in
    def initialize(parent, context)
      @parent = parent
      @context = context
    end

    def method_missing(method_sym, *args, &block)
      target_meth = "#{@context}_#{method_sym}".to_sym

      # check for a matching parent method in the context_key
      # format created by the option_properties helper
      if @parent.respond_to?(target_meth)
        @parent.send(target_meth, *args, &block)
      # check for matching method in the resource context
      else
        @parent.send(method_sym, *args, &block)
      end
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

  def camelcase
    gsub(/(^|_)(.)/) { Regexp.last_match(2).upcase }
  end
end

class Hash
  def to_kv_pairs
    reject { |_, v| v.nil? }
      .map { |k, v| "#{k}=#{v}" }
  end
end
