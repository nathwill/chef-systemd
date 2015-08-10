#
# Cookbook Name:: systemd
# Recipe:: bootchart
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

b = node['systemd']['bootchart']

systemd_bootchart 'bootchart' do
  drop_in false
  samples b['samples']
  frequency b['frequency']
  relative b['relative']
  filter b['filter']
  output b['output']
  init b['init']
  plot_memory_usage b['plot_memory_usage']
  plot_entropy_graph b['plot_entropy_graph']
  scale_x b['scale_x']
  scale_y b['scale_y']
  control_group b['control_group']
end
