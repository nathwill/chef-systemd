#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdJournald
# Library:: Chef::Resource::SystemdLogind
# Library:: Chef::Resource::SystemdResolved
# Library:: Chef::Resource::SystemdTimesyncd
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

# resources for systemd daemons

require_relative 'systemd'
require_relative 'daemon'

# TODO: deduplicate the boilerplate
class ChefSystemdCookbook
  # resource for configuring systemd-journald
  # http://www.freedesktop.org/software/systemd/man/systemd-journald.service.html
  class JournaldResource < ChefSystemdCookbook::DaemonResource
    resource_name :systemd_journald

    def conf_type(_ = nil)
      :journald
    end

    def label
      'Journal'
    end

    option_attributes Systemd::Journald::OPTIONS
  end

  # resource for configuring systemd-logind
  # http://www.freedesktop.org/software/systemd/man/systemd-logind.service.html
  class LogindResource < ChefSystemdCookbook::DaemonResource
    resource_name :systemd_logind

    def conf_type(_ = nil)
      :logind
    end

    def label
      'Login'
    end

    option_attributes Systemd::Logind::OPTIONS
  end

  # resource for configuring systemd-resolved
  # http://www.freedesktop.org/software/systemd/man/systemd-resolved.service.html
  class ResolvedResource < ChefSystemdCookbook::DaemonResource
    resource_name :systemd_resolved

    def conf_type(_ = nil)
      :resolved
    end

    def label
      'Resolve'
    end

    option_attributes Systemd::Resolved::OPTIONS
  end

  # resource for configuring systemd-timesyncd
  # http://www.freedesktop.org/software/systemd/man/systemd-timesyncd.service.html
  class TimesyncdResource < ChefSystemdCookbook::DaemonResource
    resource_name :systemd_timesyncd

    def conf_type(_ = nil)
      :timesyncd
    end

    def label
      'Time'
    end

    option_attributes Systemd::Timesyncd::OPTIONS
  end
end
