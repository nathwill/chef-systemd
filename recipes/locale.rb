#
# Cookbook Name:: systemd
# Recipe:: locale
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
# https://www.freedesktop.org/software/systemd/man/systemd-localed.service.html
#

require 'dbus/systemd/localed'
require 'set'

ruby_block 'set-locale' do
  locale = node['systemd']['locale'].to_kv_pairs

  localed = DBus::Systemd::Localed.new

  block do
    localed.SetLocale(locale, false)
  end

  not_if do
    localed.properties['Locale'].to_set == locale.to_set
  end
end
