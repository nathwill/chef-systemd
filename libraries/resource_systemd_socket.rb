#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdSocket
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
require_relative 'systemd_socket'

# manage systemd socket units
# http://www.freedesktop.org/software/systemd/man/systemd.socket.html
class Chef::Resource
  class SystemdSocket < Chef::Resource::SystemdUnit
    self.resource_name = :systemd_socket
    provides :systemd_socket

    def conf_type(_ = nil)
      :socket
    end

    def socket
      yield
    end

    include Systemd::Mixin::Exec
    include Systemd::Mixin::Kill
    include Systemd::Mixin::ResourceControl

    auto_attrs = Systemd::Socket::OPTIONS.reject do |o|
      Systemd::Mixin::Exec.instance_methods.include?(o.underscore.to_sym) ||
      Systemd::Mixin::Kill.instance_methods.include?(o.underscore.to_sym) ||
      Systemd::Mixin::ResourceControl.instance_methods.include?(o.underscore.to_sym) # rubocop: disable LineLength
    end

    option_attributes auto_attrs.to_a
  end
end
