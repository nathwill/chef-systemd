#
# Cookbook Name:: systemd
# Library:: SystemdCookbook::ResourceFactory
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

require_relative 'mixin'
require_relative 'data'

module SystemdCookbook
  module ResourceFactory
    module Unit
      def self.included(base)
        base.extend ClassMethods
        base.send :build_resource
      end

      module ClassMethods
        def build_resource
          define_method(:resource_type) { self.class.resource_type }

          resource_name "systemd_#{resource_type}".to_sym
          provides "systemd_#{resource_type}".to_sym

          include SystemdCookbook::Mixin::Unit
          include SystemdCookbook::Mixin::PropertyHashConversion
          include SystemdCookbook::Mixin::DSL

          property :user, String, desired_state: false
          property :verify, [TrueClass, FalseClass],
                   default: true,
                   desired_state: false

          data_class = resource_type.to_s.camelcase.to_sym
          data = SystemdCookbook.const_get(data_class)::OPTIONS

          option_properties data

          # Avoid chef-sugar before/after filter conflicts
          # https://github.com/nathwill/chef-systemd/issues/103
          define_method(:before) { |arg| unit_before arg }
          define_method(:after) { |arg| unit_after arg }

          Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
            action actn do
              systemd_unit "#{new_resource.name}.#{resource_type}" do
                triggers_reload new_resource.triggers_reload
                user new_resource.user if new_resource.user
                content property_hash(data)
                verify new_resource.verify
                action actn
              end
            end
          end
        end
        # rubocop: enable AbcSize
        # rubocop: enable MethodLength
      end
    end

    module DropIn
      def self.included(base)
        base.extend ClassMethods
        base.send :build_resource
      end

      module ClassMethods
        def build_resource
          define_method(:resource_type) { self.class.resource_type }

          resource_name "systemd_#{resource_type}_drop_in".to_sym
          provides "systemd_#{resource_type}_drop_in".to_sym

          include SystemdCookbook::Mixin::Unit
          include SystemdCookbook::Mixin::PropertyHashConversion
          include SystemdCookbook::Mixin::DSL

          data_class = resource_type.to_s.camelcase.to_sym
          data = SystemdCookbook.const_get(data_class)::OPTIONS

          option_properties data

          property :override, String, required: true, desired_state: false, callbacks: {
            'matches drop-in type' => ->(s) { s.end_with?(resource_type.to_s) },
          }
          property :precursor, Hash, default: {}
          property :user, String, desired_state: false
          property :drop_in_name, identity: true, desired_state: false,
                                  default: lazy { "#{override}-#{name}" }

          %w(create delete).map(&:to_sym).each do |actn|
            action actn do
              r = new_resource

              base = r.user ? '/etc/systemd/user' : '/etc/systemd/system'
              conf_d = ::File.join(base, "#{r.override}.d")

              directory conf_d do
                not_if { r.action == :delete }
              end

              uc = property_hash(data)
              r.precursor.each_pair do |rk, rv|
                rv.compare_by_identity

                uc[rk].to_h.each_pair do |k, v|
                  rv[k.dup] = v
                end

                uc[rk] = rv
              end

              u = systemd_unit r.drop_in_name do
                content uc
                action :nothing
              end

              cmd = r.user ? 'systemctl --user' : 'systemctl'

              e = execute 'daemon-reload' do
                command "#{cmd} daemon-reload"
                user(r.user) if r.user
                if r.user
                  environment(
                    'DBUS_SESSION_BUS_ADDRESS' => "unix:path=/run/user/#{node['etc']['passwd'][r.user]['uid']}/bus"
                  )
                end
                action :nothing
                only_if { r.triggers_reload }
              end

              file "#{conf_d}/#{r.name}.conf" do
                content u.to_ini
                action actn
                notifies :run, e.to_s, :immediately
              end
            end
          end
        end
        # rubocop: enable MethodLength
        # rubocop: enable AbcSize
      end
    end

    module Misc
      def self.included(base)
        base.extend ClassMethods
        base.send :build_resource
      end

      module ClassMethods
        def build_resource
          define_method(:resource_type) { self.class.resource_type }

          resource_name "systemd_#{resource_type.to_s.tr('-', '_')}".to_sym
          provides "systemd_#{resource_type.to_s.tr('-', '_')}".to_sym

          include SystemdCookbook::Mixin::PropertyHashConversion
          include SystemdCookbook::Mixin::DSL

          data_class = resource_type.to_s.tr('-', '_').to_s.camelcase.to_sym
          data = SystemdCookbook.const_get(data_class)::OPTIONS

          option_properties data

          %w(create delete).map(&:to_sym).each do |actn|
            action actn do
              conf_d = "/etc/systemd/#{resource_type}.conf.d"

              directory conf_d do
                not_if { new_resource.action == :delete }
              end

              r = systemd_unit "#{resource_type}-#{new_resource.name}" do
                content property_hash(data)
                action :nothing
              end

              file "#{conf_d}/#{new_resource.name}.conf" do
                content r.to_ini
                action actn
              end
            end
          end
        end
        # rubocop: enable MethodLength
        # rubocop: enable AbcSize
      end
    end
  end
end
