#
# Cookbook Name:: systemd
# Recipe:: ntp
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
# https://www.freedesktop.org/software/systemd/man/systemd-timesyncd.service.html
#

require 'dbus/systemd/timedated'

#
# this manages the timedated NTP property,
# which correlates to the systemd-timesyncd
# service being {en,dis}abled/{start,stopp}ed
#
ruby_block 'manage-ntp' do
  enable = node['systemd']['enable_ntp']

  timedated = DBus::Systemd::Timedated.new

  block do
    timedated.SetNTP(enable, false)
  end

  not_if do
    timedated.properties['NTP'] == enable
  end
end
