#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdAutomount
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

require_relative 'resource_systemd_unit'
require_relative 'systemd_automount'

class Chef::Resource
  class SystemdAutomount < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_automount
    provides :systemd_automount

    def conf_type(_ = nil)
      :automount
    end

    option_attributes Systemd::Automount::OPTIONS

    def automount
      yield
    end
  end
end
