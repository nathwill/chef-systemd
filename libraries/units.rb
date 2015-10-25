#
# Cookbook Name:: systemd
# Library:: Chef::Resource::SystemdAutomount
# Library:: Chef::Resource::SystemdMount
# Library:: Chef::Resource::SystemdPath
# Library:: Chef::Resource::SystemdService
# Library:: Chef::Resource::SystemdSlice
# Library:: Chef::Resource::SystemdSocket
# Library:: Chef::Resource::SystemdSwap
# Library:: Chef::Resource::SystemdTarget
# Library:: Chef::Resource.::SystemdTimer
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
require_relative 'unit'

# resources for management of systemd units
class Chef::Resource
  # resource for configuration of systemd automount units
  # http://www.freedesktop.org/software/systemd/man/systemd.automount.html
  class SystemdAutomount < Chef::Resource::SystemdUnit
    resource_name :systemd_automount
    provides :systemd_automount

    def conf_type(_ = nil)
      :automount
    end

    option_attributes Systemd::Automount::OPTIONS

    def automount
      yield
    end
  end

  # resource for configuration of systemd mount units
  # http://www.freedesktop.org/software/systemd/man/systemd.mount.html
  class SystemdMount < Chef::Resource::SystemdUnit
    resource_name :systemd_mount
    provides :systemd_mount

    def conf_type(_ = nil)
      :mount
    end

    option_attributes Systemd::Mount::OPTIONS

    def mount
      yield
    end
  end

  # resource for configuration of systemd path units
  # http://www.freedesktop.org/software/systemd/man/systemd.path.html
  class SystemdPath < Chef::Resource::SystemdUnit
    resource_name :systemd_path
    provides :systemd_path

    def conf_type(_ = nil)
      :path
    end

    option_attributes Systemd::Path::OPTIONS

    def path
      yield
    end
  end

  # resource for configuration of systemd service units
  # http://www.freedesktop.org/software/systemd/man/systemd.service.html
  class SystemdService < Chef::Resource::SystemdUnit
    resource_name :systemd_service
    provides :systemd_service

    def conf_type(_ = nil)
      :service
    end

    option_attributes Systemd::Service::OPTIONS

    def service
      yield
    end
  end

  # resource for configuration of systemd slice units
  # http://www.freedesktop.org/software/systemd/man/systemd.slice.html
  class SystemdSlice < Chef::Resource::SystemdUnit
    resource_name :systemd_slice
    provides :systemd_slice

    def conf_type(_ = nil)
      :slice
    end

    option_attributes Systemd::Slice::OPTIONS
  end

  # resource for configuration of systemd socket units
  # http://www.freedesktop.org/software/systemd/man/systemd.socket.html
  class SystemdSocket < Chef::Resource::SystemdUnit
    resource_name :systemd_socket
    provides :systemd_socket

    def conf_type(_ = nil)
      :socket
    end

    option_attributes Systemd::Socket::OPTIONS

    def socket
      yield
    end
  end

  # resource for configuration of systemd swap units
  # http://www.freedesktop.org/software/systemd/man/systemd.swap.html
  class SystemdSwap < Chef::Resource::SystemdUnit
    resource_name :systemd_swap
    provides :systemd_swap

    def conf_type(_ = nil)
      :swap
    end

    option_attributes Systemd::Swap::OPTIONS

    def swap
      yield
    end
  end

  # resource for configuration of systemd target units
  # http://www.freedesktop.org/software/systemd/man/systemd.target.html
  class SystemdTarget < Chef::Resource::SystemdUnit
    resource_name :systemd_target
    provides :systemd_target

    def conf_type(_ = nil)
      :target
    end
  end

  # resource for configuration of systemd timer units
  # http://www.freedesktop.org/software/systemd/man/systemd.timer.html
  class SystemdTimer < Chef::Resource::SystemdUnit
    resource_name :systemd_timer
    provides :systemd_timer

    def conf_type(_ = nil)
      :timer
    end

    option_attributes Systemd::Timer::OPTIONS

    def timer
      yield
    end
  end
end
