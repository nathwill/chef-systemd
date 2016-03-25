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
require_relative 'mixins'

# Base class for resources configured with ini-formatted files
class ChefSystemdCookbook
  class ConfResource < Chef::Resource::LWRPBase
    include Systemd::Mixin::DirectiveConversion

    resource_name :systemd_conf

    actions :create, :delete
    default_action :create

    # Child classes must implement. Used to
    # to locate appropriate helper modules.
    def conf_type
      raise NotImplementedError
    end

    # Converts resource to a hash with configuration sections as hash
    # keys and configuration directives as values (arrays of strings)
    def to_hash
      opts = Systemd.const_get(conf_type.capitalize)::OPTIONS

      conf = {}
      conf[label] = options_config(opts)
      conf
    end

    alias to_h to_hash
  end

  class ConfProvider < Chef::Provider::LWRPBase
    use_inline_resources

    def whyrun_supported?
      true
    end

    provides :systemd_conf if defined?(provides)

    %w( create delete ).map(&:to_sym).each do |a|
      action a do
        r = new_resource
        conf_path = Systemd::Helpers.conf_path(r)

        directory Systemd::Helpers.conf_drop_in_root(r) do
          only_if { r.drop_in }
          not_if { r.action == :delete }
        end

        # TODO: this should be reworked; it's child-class specific ugliness :(
        execute "#{r.name}.#{r.conf_type}-systemd-reload" do
          command 'systemctl daemon-reload'
          action :nothing
          only_if do
            r.is_a?(ChefSystemdCookbook::UnitResource) && r.auto_reload
          end
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
