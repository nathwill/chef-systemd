#
# Cookbook Name:: systemd
# Recipe:: hostname
#
# Copyright 2015 - 2016, The Authors
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
# https://www.freedesktop.org/software/systemd/man/hostnamectl.html
#

require 'dbus/systemd/hostnamed'

ruby_block 'set-hostname' do
  hostname = node['systemd']['hostname']

  hostnamed = DBus::Systemd::Hostnamed.new

  block do
    hostnamed.SetStaticHostname(hostname, false)
  end

  not_if do
    hostnamed.properties['StaticHostname'] == hostname
  end
end
