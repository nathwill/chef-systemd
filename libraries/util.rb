#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdUtil
# Library:: Chef::Provider::SystemdUtil
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

require_relative 'helpers'
require_relative 'conf'

class Chef::Resource
  class SystemdUtil < Chef::Resource::SystemdConf
    self.resource_name = :systemd_util
    provides :systemd_util

    attribute :drop_in, kind_of: [TrueClass, FalseClass], default: true
    attribute :conf_type, kind_of: Symbol, required: true,
                          equal_to: Systemd::Helpers::UTILS

    # default config header
    def label
      conf_type.capitalize
    end
  end
end

class Chef::Provider
  class SystemdUtil < Chef::Provider::SystemdConf
    provides :systemd_util
    Systemd::Helpers::UTILS.each do |util|
      provides "systemd_#{util}".to_sym
    end
  end
end