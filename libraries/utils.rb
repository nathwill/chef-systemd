#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdBootchart
# Library:: Chef::Resource::SystemdCoredump
# Library:: Chef::Resource::SystemdSleep
# Library:: Chef::Resource::SystemdUser
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

require_relative 'systemd'
require_relative 'util'

class Chef::Resource
  # resource for managing systemd-bootchart
  # http://www.freedesktop.org/software/systemd/man/systemd-bootchart.html
  class SystemdBootchart < Chef::Resource::SystemdUtil
    resource_name :systemd_bootchart
    provides :systemd_bootchart

    def conf_type(_ = nil)
      :bootchart
    end

    option_attributes Systemd::Bootchart::OPTIONS
  end

  # resource for managing systemd-coredump
  # http://www.freedesktop.org/software/systemd/man/systemd-coredump.html
  class SystemdCoredump < Chef::Resource::SystemdUtil
    resource_name :systemd_coredump
    provides :systemd_coredump

    def conf_type(_ = nil)
      :coredump
    end

    option_attributes Systemd::Coredump::OPTIONS
  end

  # resource for managing systemd-sleep
  # http://www.freedesktop.org/software/systemd/man/systemd-sleep.html
  class SystemdSleep < Chef::Resource::SystemdUtil
    resource_name :systemd_sleep
    provides :systemd_sleep

    def conf_type(_ = nil)
      :sleep
    end

    option_attributes Systemd::Sleep::OPTIONS
  end

  # resource for managing systemd system mode defaults
  # http://www.freedesktop.org/software/systemd/man/systemd-system.conf.html
  class SystemdSystem < Chef::Resource::SystemdUtil
    resource_name :systemd_system
    provides :systemd_system

    def conf_type(_ = nil)
      :system
    end

    def label
      'Manager'
    end

    option_attributes Systemd::System::OPTIONS
  end

  # resource for managing systemd user mode defaults
  # http://www.freedesktop.org/software/systemd/man/systemd-user.conf.html
  class SystemdUser < Chef::Resource::SystemdUtil
    resource_name :systemd_user
    provides :systemd_user

    def conf_type(_ = nil)
      :user
    end

    def label
      'Manager'
    end

    option_attributes Systemd::User::OPTIONS
  end
end
