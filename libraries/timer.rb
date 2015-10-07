#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdTimer
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

require_relative 'systemd_timer'
require_relative 'unit'

class Chef::Resource
  class SystemdTimer < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_timer
    provides :systemd_timer

    def conf_type(_ = nil)
      :timer
    end

    option_attributes Systemd::Timer::OPTIONS

    def timer
      yield
    end
  end
end
