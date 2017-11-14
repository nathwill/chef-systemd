#
# Cookbook Name:: systemd
# Recipe:: journal_extra
#
# Copyright 2016, The Authors
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
# https://www.freedesktop.org/software/systemd/man/systemd-journald.service.html
#

package 'systemd-journal-gateway' do
  only_if { platform_family?('rhel') }
end

package 'systemd-journal-remote' do
  not_if { platform_family?('rhel') || platform?('debian') }
end

# workaround for https://github.com/Foodcritic/foodcritic/issues/451
apt_package 'systemd-journal-remote' do
  default_release "#{node['lsb']['codename']}-backports"
  only_if { platform?('debian') }
end
