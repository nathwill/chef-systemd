# http://www.freedesktop.org/software/systemd/man/systemd.swap.html
#
# Cookbook Name:: systemd
# Module:: Systemd::Swap
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

require_relative 'systemd_resource_control'
require_relative 'systemd_exec'
require_relative 'systemd_kill'

module Systemd
  module Swap
    OPTIONS ||= Systemd::ResourceControl::OPTIONS
                .merge(Systemd::Exec::OPTIONS)
                .merge(Systemd::Kill::OPTIONS)
                .merge('What' => {},
                       'Priority' => {},
                       'Options' => {},
                       'TimeoutSec' => {})
  end
end
