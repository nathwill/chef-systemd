#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdSysctl
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

# manage systemd-sysctl configuration
# http://www.freedesktop.org/software/systemd/man/systemd-sysctl.html
# http://man7.org/linux/man-pages/man5/sysctl.d.5.html
class Chef::Resource
  class SystemdSysctl < Chef::Resource::LWRPBase
    self.resource_name = :systemd_sysctl

    provides :systemd_sysctl

    actions :create, :delete
    default_action :create

    attribute :value, kind_of: [String, Numeric], default: nil, required: true
  end
end
