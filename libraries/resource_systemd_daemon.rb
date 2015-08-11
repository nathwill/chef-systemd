#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdDaemon
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

require_relative 'resource_systemd_conf'
require_relative 'helpers'

# base class for daemons (see helper lib)
class Chef::Resource
  class SystemdDaemon < Chef::Resource::SystemdConf
    self.resource_name = :systemd_daemon
    provides :systemd_daemon

    attribute :drop_in, kind_of: [TrueClass, FalseClass], default: true
    attribute :conf_type, kind_of: Symbol, required: true, default: :journald,
                          equal_to: Systemd::Helpers::DAEMONS
  end
end
