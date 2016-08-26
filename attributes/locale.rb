#
# Cookbook Name:: systemd
# Attributes:: locale
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
