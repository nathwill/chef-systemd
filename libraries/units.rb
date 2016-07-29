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

class SystemdCookbook
  class Units
    class Provider < Chef::Provider::SystemdUnit
      Systemd::UNITS.each do |unit|
        provides "systemd_#{unit}".to_sym
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

    Systemd::UNITS.each do |unit|
      next if Systemd::BUS_ONLY_UNITS.include?(unit)

      SystemdCookbook::Units.const_set(
        unit.capitalize,
        Class.new(Chef::Resource::SystemdUnit) do
          UNIT ||= unit

          include Systemd::Mixins::Unit
          include Systemd::Mixins::Conversion

          resource_name "systemd_#{unit}".to_sym
          option_properties Systemd.const_get(unit.capitalize.to_sym)::OPTIONS

          define_method(unit.to_sym) { |&b| b.call }

          def unit_type; UNIT; end

          def to_ini
            content property_hash(Systemd.const_get(UNIT.capitalize.to_sym)::OPTIONS)
            super
          end
        end
      )
    end
  end
end
