#
# Cookbook Name:: systemd
#
# Copyright 2016 The Authors
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

class SystemdUnits
  class Automount < Chef::Resource::SystemdUnit
    include Systemd::Mixin::DirectiveConversion

    resource_name :systemd_automount

    sd_properties Systemd::Automount::OPTIONS

    def to_ini
      content(property_hash(Systemd::Automount::OPTIONS))
      super
    end
  end

  class Device < Chef::Resource::SystemdUnit
    resource_name :systemd_device
  end

  class Mount < Chef::Resource::SystemdUnit
    resource_name :systemd_mount
  end

  class Path < Chef::Resource::SystemdUnit
    resource_name :systemd_path
  end

  class Scope < Chef::Resource::SystemdUnit
    resource_name :systemd_scope
  end

  class Service < Chef::Resource::SystemdUnit
    resource_name :systemd_service
  end

  class Slice < Chef::Resource::SystemdUnit
    resource_name :systemd_slice
  end

  class Socket < Chef::Resource::SystemdUnit
    resource_name :systemd_socket
  end

  class Swap < Chef::Resource::SystemdUnit
    resource_name :systemd_swap
  end

  class Target < Chef::Resource::SystemdUnit
    resource_name :systemd_target
  end

  class Timer < Chef::Resource::SystemdUnit
    resource_name :systemd_timer
  end
end
