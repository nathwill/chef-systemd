#
# Cookbook Name:: systemd
# Attributes:: default
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

default['systemd'].tap do |s|
  # Ref: http://www.freedesktop.org/software/systemd/man/hostname.html
  s['hostname'] = nil

  # Ref: http://www.freedesktop.org/software/systemd/man/timedatectl.html
  # See timedatectl list-timezones for options
  s['timezone'] = 'UTC'

  # Ref: http://www.freedesktop.org/software/systemd/man/timesyncd.conf.html
  s['enable_ntp'] = true

  # Ref: https://www.freedesktop.org/software/systemd/man/machinectl.html
  s['machine_pool_limit'] = nil
end

# Ref: http://www.freedesktop.org/software/systemd/man/timedatectl.html
default['systemd']['real_time_clock'].tap do |rtc|
  rtc['mode'] = 'utc'
  rtc['adjust_system_clock'] = false
end

# Ref: http://www.freedesktop.org/software/systemd/man/locale.conf.html
default['systemd']['locale'].tap do |l|
  l['LANG'] = 'en_US.UTF-8'
  l['LANGUAGE'] = nil
  l['LC_CTYPE'] = nil
  l['LC_NUMERIC'] = nil
  l['LC_TIME'] = nil
  l['LC_COLLATE'] = nil
  l['LC_MONETARY'] = nil
  l['LC_MESSAGES'] = nil
  l['LC_PAPER'] = nil
  l['LC_NAME'] = nil
  l['LC_ADDRESS'] = nil
  l['LC_TELEPHONE'] = nil
  l['LC_MEASUREMENT'] = nil
  l['LC_IDENTIFICATION'] = nil
end

# Ref: http://www.freedesktop.org/software/systemd/man/vconsole.conf.html
default['systemd']['vconsole'].tap do |v|
  v['KEYMAP'] = 'us'
  v['KEYMAP_TOGGLE'] = nil
  v['FONT'] = 'latarcyrheb-sun16'
  v['FONT_MAP'] = nil
  v['FONT_UNIMAP'] = nil
end
