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

require 'chef/resource/systemd_unit'
require_relative 'systemd'
require_relative 'mixins'
require_relative 'helpers'

class SystemdUnit
  class Automount < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_automount

    option_properties Systemd::Automount::OPTIONS

    def automount
      yield
    end

    def to_ini
      content(property_hash(Systemd::Automount::OPTIONS))
      super
    end
  end

  class Device < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_device

    option_properties Systemd::Device::OPTIONS

    def device
      yield
    end

    def to_ini
      content(property_hash(Systemd::Device::OPTIONS))
      super
    end
  end

  class Mount < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_mount

    option_properties Systemd::Mount::OPTIONS

    def mount
      yield
    end

    def to_ini
      content(property_hash(Systemd::Mount::OPTIONS))
      super
    end
  end

  class Path < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_path

    option_properties Systemd::Path::OPTIONS

    def path
      yield
    end

    def to_ini
      content(property_hash(Systemd::Path::OPTIONS))
      super
    end
  end

  class Scope < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_scope

    option_properties Systemd::Scope::OPTIONS

    def scope
      yield
    end

    def to_ini
      content(property_hash(Systemd::Scope::OPTIONS))
      super
    end
  end

  class Service < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_service

    option_properties Systemd::Service::OPTIONS

    def service
      yield
    end

    def to_ini
      content(property_hash(Systemd::Service::OPTIONS))
      super
    end
  end

  class Slice < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_slice

    def slice
      yield
    end

    option_properties Systemd::Slice::OPTIONS

    def to_ini
      content(property_hash(Systemd::Slice::OPTIONS))
      super
    end
  end

  class Socket < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_socket

    option_properties Systemd::Socket::OPTIONS

    def socket
      yield
    end

    def to_ini
      content(property_hash(Systemd::Socket::OPTIONS))
      super
    end
  end

  class Swap < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_swap

    option_properties Systemd::Swap::OPTIONS

    def swap
      yield
    end

    def to_ini
      content(property_hash(Systemd::Swap::OPTIONS))
      super
    end
  end

  class Target < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_target

    option_properties Systemd::Target::OPTIONS

    def target
      yield
    end

    def to_ini
      content(property_hash(Systemd::Target::OPTIONS))
      super
    end
  end

  class Timer < Chef::Resource::SystemdUnit
    include Systemd::Mixins::Unit
    include Systemd::Mixins::Conversion

    resource_name :systemd_timer

    option_properties Systemd::Timer::OPTIONS

    def time
      yield
    end

    def to_ini
      content(property_hash(Systemd::Timer::OPTIONS))
      super
    end
  end
end
