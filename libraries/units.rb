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

require 'chef/resource/systemd_unit'
require 'chef/provider/systemd_unit'

require_relative 'systemd'
require_relative 'mixins'
require_relative 'helpers'

class SystemdUnit
  class Provider < Chef::Provider::SystemdUnit
    Systemd::UNIT_TYPES.each do |unit_type|
      provides "systemd_#{unit_type}".to_sym, os: 'linux'
    end

    def unit_path
      fname = "#{new_resource.name}.#{new_resource.unit_type}"

      if new_resource.user
        "/etc/systemd/user/#{fname}"
      else
        "/etc/systemd/system/#{fname}"
      end
    end
  end
end

Systemd::UNIT_TYPES.each do |t|
  SystemdUnit.const_set(
    t.capitalize,
    Class.new(Chef::Resource::SystemdUnit) do
      UNIT_TYPE ||= t

      include Systemd::Mixins::Unit
      include Systemd::Mixins::Conversion

      resource_name "systemd_#{t}".to_sym
      option_properties Systemd.const_get(t.capitalize.to_sym)::OPTIONS

      define_method(t.to_sym) { |&b| b.call }

      def unit_type; UNIT_TYPE; end

      def to_ini
        content property_hash(
          Systemd.const_get(UNIT_TYPE.capitalize.to_sym)::OPTIONS
        )
        super
      end
    end
  )
end
