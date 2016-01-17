#
# Cookbook Name:: systemd
# Attributes:: coredump
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

# Ref: http://www.freedesktop.org/software/systemd/man/coredump.conf.html
default['systemd']['coredump'].tap do |c|
  c['storage'] = nil
  c['compress'] = true
  c['process_size_max'] = nil
  c['external_size_max'] = nil
  c['journal_size_max'] = nil
  c['max_use'] = nil
  c['keep_free'] = nil
end
