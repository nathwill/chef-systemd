#
# Cookbook Name:: systemd
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

require 'chef/resource/directory'
require 'chef/resource/file'
require 'chef/resource'
require 'chef/provider'

require_relative 'systemd'
require_relative 'mixins'
require_relative 'helpers'

class SystemdCookbook
  class Utils
    class Provider < Chef::Provider
      Systemd::UTILS.each do |util|
        provides "systemd_#{util}".to_sym
      end

      def load_current_resource
        @current_resource = SystemdCookbook::Utils.const_get(new_resource.util_type)
                                                  .new(new_resource.name)
        current_resource.content = ::File.read(util_path) if ::File.exist?(util_path)
      end

      def action_create
        if @content != new_resource.to_ini
          converge_by("creating systemd util config: #{new_resource.name}") do
            Chef::Resource::Directory.new(::File.dirname(util_path), run_context)
                                     .run_action(:create)
            manage_util_config(:create)
          end
        end
      end

      def action_delete
        if ::File.exist?(util_path)
          converge_by("deleting systemd util config: #{new_resource.name}") do
            manage_util_config(:delete)
          end
        end
      end

      private

      def util_path
        "/etc/systemd/#{new_resource.util_type}.conf.d/#{new_resource.name}.conf"
      end

      def manage_util_config(action = :nothing)
        Chef::Resource::File.new(util_path, run_context).tap do |f|
          f.content new_resource.to_ini
        end.run_action(action)
      end
    end

    Systemd::UTILS.each do |util|
      SystemdCookbook::Utils.const_set(
        util.capitalize,
        Class.new(Chef::Resource) do
          UTIL ||= util

          include Systemd::Mixins::Conversion

          resource_name "systemd_#{util}".to_sym

          default_action :create
          allowed_actions :create, :delete

          def util_type; UTIL; end

          property :content, String, desired_state: true

          option_properties Systemd.const_get(util.capitalize)::OPTIONS

          def to_ini
            Systemd::Helpers.hash_to_ini(
              property_hash(Systemd.const_get(UTIL.capitalize)::OPTIONS)
            )
          end
        end
      )
    end
  end
end
