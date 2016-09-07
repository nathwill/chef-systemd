#
# Cookbook Name:: systemd
# Library:: Systemd::Mixins
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

require_relative 'systemd'

module Systemd
  module Mixins
    module ResourceFactory
      module Unit
        def self.included(base)
          base.extend ClassMethods
          base.send :build_resource
        end

        module ClassMethods
          # rubocop: disable AbcSize
          def build_resource
            resource_name "systemd_#{unit_type}".to_sym
            provides "systemd_#{unit_type}".to_sym

            option_properties Systemd.const_get(unit_type.to_s.camelcase.to_sym)::OPTIONS

            define_method(unit_type) { |&b| b.call if b }

            default_action :create

            Chef::Resource::SystemdUnit.allowed_actions.each do |actn|
              action actn do
                systemd_unit "#{new_resource.name}.#{unit_type}" do
                  triggers_reload new_resource.triggers_reload
                  content property_hash(Systemd.const_get(unit_type.to_s.camelcase.to_sym)::OPTIONS)
                  action actn
                end
              end
            end
          end
          # rubocop: enable AbcSize
        end
      end

      module DropIn
        def self.included(base)
          base.extend ClassMethods
          base.send :build_resource
        end

        module ClassMethods
          # rubocop: disable MethodLength
          # rubocop: disable AbcSize
          def build_resource
            resource_name "systemd_#{unit_type}_drop_in".to_sym
            provides "systemd_#{unit_type}_drop_in".to_sym

            option_properties Systemd.const_get(unit_type.to_s.camelcase.to_sym)::OPTIONS
            property :override, String, required: true, callbacks: {
              'matches drop-in type' => ->(s) { s.end_with?(unit_type.to_s) }
            }

            define_method(unit_type) { |&b| b.call if b }

            default_action :create

            %w( create delete ).map(&:to_sym).each do |actn|
              action actn do
                r = new_resource

                conf_d = "/etc/systemd/system/#{r.override}.d"

                directory conf_d do
                  not_if { r.action == :delete }
                end

                u = systemd_unit "#{r.override}_drop-in_#{r.name}" do
                  content property_hash(Systemd.const_get(unit_type.to_s.camelcase.to_sym)::OPTIONS)
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
          # rubocop: enable MethodLength
          # rubocop: enable AbcSize
        end
      end
    end

    module Unit
      def install
        yield
      end

      def self.included(base)
        base.send :property, :triggers_reload,
                  [TrueClass, FalseClass],
                  default: true,
                  desired_state: false
      end
    end

    module PropertyHashConversion
      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      module ClassMethods
        def option_properties(options = {})
          options.each_pair do |_, opts|
            opts.each_pair do |opt, conf|
              property opt.underscore.to_sym, conf.merge(desired_state: false)
            end
          end
        end
      end

      module InstanceMethods
        # rubocop: disable AbcSize
        def property_hash(options = {})
          result = {}

          options.each_pair do |heading, opts|
            conf = opts.reject do |opt, _|
              send(opt.underscore.to_sym).nil?
            end

            result[heading] = conf.map do |opt, _|
              [opt.camelcase, option_value(send(opt.underscore.to_sym))]
            end.to_h
          end

          result.delete_if { |_, v| v.empty? }
        end
        # rubocop: enable AbcSize

        def option_value(obj)
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
  end
end
