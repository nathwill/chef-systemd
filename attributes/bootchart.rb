#
# Cookbook Name:: systemd
# Attributes:: bootchart
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

# Ref: http://man7.org/linux/man-pages/man5/bootchart.conf.5.html
default['systemd']['bootchart'].tap do |b|
  b['samples'] = nil
  b['frequency'] = nil
  b['relative'] = nil
  b['filter'] = nil
  b['output'] = '/run/log'
  b['init'] = nil
  b['plot_memory_usage'] = nil
  b['plot_entropy_graph'] = nil
  b['scale_x'] = nil
  b['scale_y'] = nil
  b['control_group'] = nil
end
