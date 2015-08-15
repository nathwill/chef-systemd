#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdModules
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

require 'chef/resource/lwrp_base'

# manage kernel modules
# http://www.freedesktop.org/software/systemd/man/modules-load.d.html
# http://www.freedesktop.org/software/systemd/man/systemd-modules-load.service.html
class Chef::Resource
  class SystemdModules < Chef::Resource::LWRPBase
    self.resource_name = :systemd_modules

    provides :systemd_modules

    actions :create, :delete, :load, :unload
    default_action :create

    attribute :blacklist, kind_of: [TrueClass, FalseClass], default: false
    attribute :modules, kind_of: Array, default: %w(), required: true
  end
end
