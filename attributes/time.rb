#
# Cookbook Name:: systemd
# Attributes:: timesyncd
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

# Ref: http://www.freedesktop.org/software/systemd/man/timedatectl.html
# Ref: http://www.freedesktop.org/software/systemd/man/timesyncd.conf.html
default['systemd'].tap do |s|
  # See timedatectl list-timezones
  s['timezone'] = 'UTC'

  s['enable_ntp'] = true

  s['timesyncd'].tap do |ts|
    ts['ntp'] = 0.upto(3).map { |i| "#{i}.pool.ntp.org" }

    ts['fallback_ntp'] = 0.upto(3).map do |i|
      "#{i}.#{node['platform']}.pool.ntp.org"
    end
  end
end
