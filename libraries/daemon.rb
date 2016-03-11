#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdDaemon
# Library:: Chef::Provider::SystemdDaemon
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

require_relative 'helpers'
require_relative 'conf'

# base class for daemon resources
class ChefSystemdCookbook
  class DaemonResource < ChefSystemdCookbook::ConfResource
    resource_name :systemd_daemon

    attribute :drop_in, kind_of: [TrueClass, FalseClass], default: true
    attribute :conf_type, kind_of: Symbol, required: true,
                          equal_to: Systemd::Helpers::DAEMONS
  end

  class DaemonProvider < ChefSystemdCookbook::ConfProvider
    provides :systemd_daemon if defined?(provides)
    Systemd::Helpers::DAEMONS.each do |daemon|
      provides "systemd_#{daemon}".to_sym if defined?(provides)
    end
  end
end
