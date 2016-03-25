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

# resources for management of systemd units

require 'mixlib/shellout'

require_relative 'systemd'
require_relative 'unit'

# TODO: deduplicate the boilerplate
class ChefSystemdCookbook
  # resource for configuration of systemd automount units
  # http://www.freedesktop.org/software/systemd/man/systemd.automount.html
  class AutomountResource < ChefSystemdCookbook::UnitResource
    resource_name :systemd_automount

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
  class MountResource < ChefSystemdCookbook::UnitResource
    resource_name :systemd_mount

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
  class PathResource < ChefSystemdCookbook::UnitResource
    resource_name :systemd_path

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
  class ServiceResource < ChefSystemdCookbook::UnitResource
    resource_name :systemd_service

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
  class SliceResource < ChefSystemdCookbook::UnitResource
    resource_name :systemd_slice

    def conf_type(_ = nil)
      :slice
    end

    option_attributes Systemd::Slice::OPTIONS
  end

  # resource for configuration of systemd socket units
  # http://www.freedesktop.org/software/systemd/man/systemd.socket.html
  class SocketResource < ChefSystemdCookbook::UnitResource
    resource_name :systemd_socket

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
  class SwapResource < ChefSystemdCookbook::UnitResource
    resource_name :systemd_swap

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
  class TargetResource < ChefSystemdCookbook::UnitResource
    resource_name :systemd_target

    def conf_type(_ = nil)
      :target
    end
  end

  # resource for configuration of systemd timer units
  # http://www.freedesktop.org/software/systemd/man/systemd.timer.html
  class TimerResource < ChefSystemdCookbook::UnitResource
    resource_name :systemd_timer

    def conf_type(_ = nil)
      :timer
    end

    option_attributes Systemd::Timer::OPTIONS

    def timer
      yield
    end
  end

  class TargetProvider < ChefSystemdCookbook::UnitProvider
    provides :systemd_target if defined?(provides)

    action :set_default do
      r = new_resource

      current_default = Mixlib::ShellOut.new('systemctl get-default')
                                        .tap(&:run_command).stdout.chomp

      target_default = "#{r.name}.#{r.conf_type}"

      e = execute "systemctl set-default #{target_default}" do
        not_if { current_default == target_default }
      end

      new_resource.updated_by_last_action(e.updated_by_last_action?)
    end
  end
end
