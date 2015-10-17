#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdConf
# Library:: Chef::Provider::SystemdConf
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
require 'chef/provider/lwrp_base'
require_relative 'helpers'

# Base class for resources configured with ini-formatted files
class Chef::Resource
  class SystemdConf < Chef::Resource::LWRPBase
    self.resource_name = :systemd_conf
    provides :systemd_conf

    actions :create, :delete
    default_action :create

    # Converts resource to a hash with configuration sections
    # as hash keys and configuration directives as values (arrays of strings)
    def to_hash
      opts = Systemd.const_get(conf_type.capitalize)::OPTIONS

      conf = {}
      conf[label] = options_config(opts)
      conf
    end

    alias_method :to_h, :to_hash

    private

    def self.option_attributes(options = {})
      options.each_pair do |name, config|
        attribute name.underscore.to_sym, config
      end
    end

    # converts configuration hash (keys as directives, config as values)
    # to an array of strings with camelized directive and stringified values
    def options_config(opts = {})
      opts.reject { |o, _| send(o.underscore.to_sym).nil? }.map do |name, _|
        "#{name.camelize}=#{conf_string(send(name.underscore.to_sym))}"
      end
    end

    # converts configuration options into the appropriate string format
    def conf_string(obj)
      case obj
      when Hash
        obj.map { |k, v| "\"#{k}=#{v}\"" }.join(' ')
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

class Chef::Provider
  class SystemdConf < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_conf

    %i( create delete ).each do |a|
      action a do
        r = new_resource
        conf_path = Systemd::Helpers.conf_path(r)

        directory Systemd::Helpers.conf_drop_in_root(r) do
          only_if { r.drop_in }
          not_if { r.action == :delete }
        end

        execute "#{r.name}.#{r.conf_type}-systemd-reload" do
          command 'systemctl daemon-reload'
          action :nothing
          only_if { r.is_a?(Chef::Resource::SystemdUnit) }
          subscribes :run, "file[#{conf_path}]", :immediately
        end

        f = file conf_path do
          content Systemd::Helpers.ini_config(r.to_hash)
          action a
        end

        new_resource.updated_by_last_action(f.updated_by_last_action?)
      end
    end
  end
end
