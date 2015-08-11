#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdJournald
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

require_relative 'resource_systemd_daemon'
require_relative 'systemd_journald'

# manage systemd-journald
# http://www.freedesktop.org/software/systemd/man/systemd-journald.html
class Chef::Resource
  class SystemdJournald < Chef::Resource::SystemdDaemon
    self.resource_name = :systemd_journald
    provides :systemd_journald

    def conf_type(_ = nil)
      :journald
    end

    def label
      'Journal'
    end

    option_attributes Systemd::Journald::OPTIONS
  end
end
