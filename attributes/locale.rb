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
  l['lang'] = 'en_US.UTF-8'
  l['language'] = nil
  l['lc_ctype'] = nil
  l['lc_numeric'] = nil
  l['lc_time'] = nil
  l['lc_collate'] = nil
  l['lc_monetary'] = nil
  l['lc_messages'] = nil
  l['lc_paper'] = nil
  l['lc_name'] = nil
  l['lc_address'] = nil
  l['lc_telephone'] = nil
  l['lc_measurement'] = nil
  l['lc_identification'] = nil
end
