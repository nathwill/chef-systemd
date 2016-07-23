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

module Systemd
  module Mixins
    module Unit
      def install
        yield
      end
    end

    module Conversion
      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      module ClassMethods
        def option_properties(options = {})
          options.each_pair do |_, opts|
            opts.each_pair do |o, c|
              property o.underscore.to_sym, c.merge(desired_state: false)
            end
          end
        end
      end

      module InstanceMethods
        def property_hash(options = {})
          result = {}

          options.each_pair do |heading, opts|
            conf = opts.reject do |opt, _|
              send(opt.underscore.to_sym).nil?
            end

            result[heading] = conf.map do |opt, _|
              [opt.camelize, option_value(send(opt.underscore.to_sym))]
            end.to_h
          end

          result
        end

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
