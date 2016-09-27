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

          include SystemdCookbook::Mixin::Unit
          include SystemdCookbook::Mixin::PropertyHashConversion

          resource_name "systemd_#{resource_type}".to_sym
          provides "systemd_#{resource_type}".to_sym

          option_properties(
            SystemdCookbook.const_get(resource_type.to_s.camelcase.to_sym)::OPTIONS
          )

          define_method(:method_missing) do |name, *args, &blk|
            if @context && respond_to?("#{@context}_#{name}")
              send("#{@context}_#{name}", *args, &blk)
            end
          end

          SystemdCookbook.const_get(resource_type.to_s.camelcase.to_sym)::OPTIONS.keys.each do |sect|
            define_method(sect.underscore.to_sym) do |&blk|
              @context = sect.underscore.to_sym
              instance_eval(&blk)
              @context = nil
            end
          end

          default_action :create

          Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
            action actn do
              systemd_unit "#{new_resource.name}.#{resource_type}" do
                triggers_reload new_resource.triggers_reload
                content property_hash(
                  SystemdCookbook.const_get(resource_type.to_s.camelcase.to_sym)::OPTIONS
                )
                action actn
              end
            end
          end
        end
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

          include SystemdCookbook::Mixin::Unit
          include SystemdCookbook::Mixin::PropertyHashConversion

          resource_name "systemd_#{resource_type}_drop_in".to_sym
          provides "systemd_#{resource_type}_drop_in".to_sym

          option_properties(
            SystemdCookbook.const_get(resource_type.to_s.camelcase.to_sym)::OPTIONS
          )
          property :override, String, required: true, callbacks: {
            'matches drop-in type' => ->(s) { s.end_with?(resource_type.to_s) }
          }

          property :drop_in_name, identity: true,
                                  default: lazy { "#{override}-#{name}" }

          define_method(:method_missing) do |name, *args, &blk|
            if @context && respond_to?("#{@context}_#{name}")
              send("#{@context}_#{name}", *args, &blk)
            end
          end

          SystemdCookbook.const_get(resource_type.to_s.camelcase.to_sym)::OPTIONS.keys.each do |sect|
            define_method(sect.underscore.to_sym) do |&blk|
              @context = sect.underscore.to_sym
              instance_eval(&blk)
              @context = nil
            end
          end

          default_action :create

          %w( create delete ).map(&:to_sym).each do |actn|
            action actn do
              r = new_resource

              conf_d = "/etc/systemd/system/#{r.override}.d"

              directory conf_d do
                not_if { r.action == :delete }
              end

              u = systemd_unit r.drop_in_name do
                content property_hash(
                  SystemdCookbook.const_get(resource_type.to_s.camelcase.to_sym)::OPTIONS
                )
                action :nothing
              end

              execute 'systemctl daemon-reload' do
                action :nothing
                only_if { r.triggers_reload }
              end

              file "#{conf_d}/#{r.name}.conf" do
                content u.to_ini
                action actn
                notifies :run, 'execute[systemctl daemon-reload]', :immediately
              end
            end
          end
        end
      end
    end

    module Daemon
      def self.included(base)
        base.extend ClassMethods
        base.send :build_resource
      end

      module ClassMethods
        def build_resource
          define_method(:resource_type) { self.class.resource_type }

          include SystemdCookbook::Mixin::PropertyHashConversion

          resource_name "systemd_#{resource_type}".to_sym
          provides "systemd_#{resource_type}".to_sym

          option_properties(
            SystemdCookbook.const_get(resource_type.to_s.camelcase.to_sym)::OPTIONS
          )

          define_method(:method_missing) do |name, *args, &blk|
            if @context && respond_to?("#{@context}_#{name}")
              send("#{@context}_#{name}", *args, &blk)
            end
          end

          SystemdCookbook.const_get(resource_type.to_s.camelcase.to_sym)::OPTIONS.keys.each do |sect|
            define_method(sect.underscore.to_sym) do |&blk|
              @context = sect.underscore.to_sym
              instance_eval(&blk)
              @context = nil
            end
          end

          default_action :create

          %w( create delete ).map(&:to_sym).each do |actn|
            action actn do
              conf_d = "/etc/systemd/#{resource_type}.conf.d"

              directory conf_d do
                not_if { new_resource.action == :delete }
              end

              r = systemd_unit "#{resource_type}-#{new_resource.name}" do
                content property_hash(
                  SystemdCookbook.const_get(resource_type.to_s.camelcase.to_sym)::OPTIONS
                )
                action :nothing
              end

              file "#{conf_d}/#{new_resource.name}.conf" do
                content r.to_ini
                action actn
              end
            end
          end
        end
      end
    end
  end
end
