#
# Cookbook Name:: systemd
# Library:: SystemdCookbook::Mixin
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

require_relative 'helpers'

module SystemdCookbook
  module Mixin
    module DSL
      def self.included(base)
        base.extend ClassMethods
        base.send :build_dsl
      end

      module ClassMethods
        def build_dsl
          data_class = resource_type.to_s.tr('-', '_').camelcase.to_sym

          SystemdCookbook.const_get(data_class)::OPTIONS.keys.each do |sect|
            define_method(sect.underscore.to_sym) do |&block|
              ctx = SystemdCookbook::OptionEvalContext.new(self, sect.underscore.to_sym)
              ctx.instance_exec(&block)
            end
          end
        end
      end
    end

    module Unit
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
          options.each_pair do |section, opts|
            opts.each_pair do |opt, conf|
              property "#{section.underscore}_#{opt.underscore}".to_sym,
                       conf.merge(desired_state: false)
            end
          end
        end
      end

      module InstanceMethods
        def property_hash(options = {})
          result = {}

          options.each_pair do |section, opts|
            conf = opts.reject do |opt, _|
              send("#{section.underscore}_#{opt.underscore}".to_sym).nil?
            end

            result[section] = conf.map do |opt, _|
              [
                opt.camelcase,
                option_value(
                  send("#{section.underscore}_#{opt.underscore}".to_sym)
                ),
              ]
            end.to_h
          end

          result.delete_if { |_, v| v.empty? }
        end

        def option_value(obj)
          case obj
          when Hash
            obj.to_kv_pairs.join(' ')
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
