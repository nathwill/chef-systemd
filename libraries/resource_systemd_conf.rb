#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdConf
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

# This is the base class for daemons, utils, and units
class Chef::Resource
  class SystemdConf < Chef::Resource::LWRPBase
    self.resource_name = :systemd_conf
    provides :systemd_conf

    actions :create, :delete
    default_action :create

    # generate hash suitable for ini-converge (see helpers lib)
    def to_hash
      opts = Systemd.const_get(conf_type.capitalize)::OPTIONS

      conf = {}
      conf[label] = options_config(opts)
      conf
    end

    alias_method :to_h, :to_hash

    private

    # generates chef attributes from options array
    def self.option_attributes(options = [])
      options.each do |option|
        attribute option.underscore.to_sym, kind_of: String, default: nil
      end
    end

    # generates kv pairs from resource attributes
    def options_config(opts = [])
      opts.reject { |o| send(o.underscore.to_sym).nil? }.map do |opt|
        "#{opt.camelize}=#{conf_string(send(opt.underscore.to_sym))}"
      end
    end

    # generates config strings from structured data
    def conf_string(obj)
      case obj.class
      when Hash
        obj.map { |k, v| "#{k}=#{v}" }.join(' ')
      when Array
        obj.join(' ')
      when TrueClass, FalseClass
        obj ? 'yes' : 'no'
      else
        obj.to_s
      end
    end
  end
end
