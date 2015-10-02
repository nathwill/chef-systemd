#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdNetdev
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

# base class for netdev resources
class Chef::Resource
  class SystemdNetdev < Chef::Resource::SystemdConf
    self.resource_name = :systemd_netdev
    provides :systemd_netdev

    attribute :kind, kind_of: String, required: true, equal_to: %w(
      bond bridge dummy gre gretap ip6gre ip6tnl ip6gretap ipip
      ipvlan macvlan macvtap sit tap tun veth vlan vti vti6 vxlan
    )
    attribute :description, kind_of: String
    attribute :name, kind_of: String, required: true
    attribute :mtu_bytes, kind_of: [Integer, String]
    attribute :mac_address, kind_of: String

    def match
      yield
    end

    def net_dev
      yield
    end
  end
end
