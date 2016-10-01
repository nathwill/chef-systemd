#
# Cookbook Name:: systemd
# Library:: SystemdCookbook::Bus
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

require 'dbus'

module SystemdCookbook
  module Bus
    class Manager
      def initialize(session_bus = nil)
        @service = if session_bus
                     DBus::SessionBus.instance
                                     .service('org.freedesktop.systemd1')
                   else
                     DBus::SystemBus.instance
                                    .service('org.freedesktop.systemd1')
                   end
        @object = @service.object('/org/freedesktop/systemd1')
                          .tap(&:introspect)
        @units = {}; refresh_units
      end

      def get_unit(unit_name)
        @units[unit_name]
      end

      def get_unit_by_pid(pid)

      end

      def load_unit(unit_name)

      end

      def start_unit(unit_name, mode = 'replace')

      end

      def start_unit_replace(old_unit, new_unit, mode = 'replace')

      end

      def stop_unit(unit_name, mode = 'replace')

      end

      def reload_unit(unit_name, mode = 'replace')
        
      end

      def restart_unit(unit_name, mode = 'replace')

      end

      def try_restart_unit(unit_name, mode = 'replace')

      end

      def reload_or_restart_unit(unit_name, mode = 'replace')

      end

      def reload_or_try_restart_unit(unit_name, mode = 'replace')

      end

      def kill_unit(unit_name, who, signal)

      end

      def reset_failed_unit(unit_name)

      end

      def get_job(id)

      end

      def cancel_job(id)

      end

      def clear_jobs

      end

      def reset_failed

      end

      def list_units

      end

      def list_jobs

      end

      def subscribe

      end

      def unsubscribe

      end

      def create_snapshot(name, cleanup)

      end

      def remove_snapshot(name)

      end

      def reload

      end

      def reexecute

      end

      def exit

      end

      def reboot

      end

      def power_off

      end

      def halt

      end

      def k_exec

      end

      def switch_root(new_root, init)

      end

      def set_environment(names)

      end

      def unset_environment(names)

      end

      def unset_and_set_environment(unset, set)

      end

      def list_unit_files

      end

      def get_unit_file_state(file)

      end

      def enable_unit_files(files, runtime, force)

      end

      def disable_unit_files(files, runtime)

      end

      def reenable_unit_files(files, runtime, force)

      end

      def link_unit_files(files)

      end

      def preset_unit_files(files, runtime, force)

      end

      def mask_unit_files(files, runtime, force)

      end

      def unmask_unit_files(files, runtime, force)

      end

      def set_default_target(files)

      end

      def get_default_target

      end

      def set_unit_properties(name, runtime, properties)

      end

      def start_transient_unit(name, mode, properties, aux)

      end

      def properties

      end

      def refresh
        @units.clear
        list_units.first.each do |unit|
          current_unit = SystemdCookbook::Bus::Unit.new(unit)
          @units[unit.name] = current_unit
        end
      end
    end

    class Unit
      def initialize(name)

      end

      def start(mode = 'replace')

      end

      def stop(mode = 'replace')

      end

      def reload(mode = 'replace')

      end

      def try_restart(mode = 'replace')
        
      end

      def reload_or_restart(mode = 'replace')

      end

      def reload_or_try_restart(mode = 'replace')

      end

      def kill(who, signal)

      end

      def reset_failed

      end

      def set_properties(runtime, properties)

      end

      def properties

      end
    end

    class Service < Unit

    end

    class Socket < Unit

    end

    class Target < Unit

    end

    class Device < Unit

    end

    class Mount < Unit

    end

    class Automount < Unit

    end

    class Snapshot < Unit
      def remove

      end
    end

    class Timer < Unit

    end

    class Swap < Unit

    end

    class Path < Unit

    end

    class Slice < Unit

    end

    class Scope < Unit
      def abandon

      end
    end

    class Job
      def cancel

      end

      def properties

      end
    end
  end
end
