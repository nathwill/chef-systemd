# http://www.freedesktop.org/software/systemd/man/bootchart.conf.html
#
# Cookbook Name:: systemd
# Module:: Systemd::Bootchart
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
#

module Systemd
  module Bootchart
    OPTIONS ||= {
      'Samples' => { kind_of: Integer },
      'Frequency' => { kind_of: Integer },
      'Relative' => { kind_of: [TrueClass, FalseClass] },
      'Filter' => { kind_of: [TrueClass, FalseClass] },
      'Output' => {},
      'Init' => {},
      'PlotMemoryUsage' => { kind_of: [TrueClass, FalseClass] },
      'PlotEntropyGraph' => { kind_of: [TrueClass, FalseClass] },
      'ScaleX' => { kind_of: Integer },
      'ScaleY' => { kind_of: Integer },
      'ControlGroup' => { kind_of: [TrueClass, FalseClass] }
    }
  end
end
